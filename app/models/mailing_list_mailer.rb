# Send email to mailing list. Also receives email from Mailman for archives. Old, but battle-tested, code.
class MailingListMailer < ActionMailer::Base
  # Reply just to sender of post, not the whole list
  def private_reply(reply_post, to)
    raise("'To' cannot be blank") if to.blank?
    mail(
      :subject => reply_post.subject,
      :to => to,
      :from => "#{reply_post.from_name} <#{reply_post.from_email}>",
      :sent_on => reply_post.date.to_s,
      :body => reply_post.body.to_s
    )
  end

  def post(new_post)
    mail(
      :subject => new_post.subject,
      :to => new_post.mailing_list.name,
      :from => "#{new_post.from_name} <#{new_post.from_email}>",
      :sent_on => new_post.date.to_s,
      :body => new_post.body.to_s
    )
  end

  # Expects raw email from Mailman archiver
  # Really need tricky sender logic for web posts? Shouldn't web
  # posts be forwarded through list, too? If so, update test data
  def receive(email)
    post = Post.new

    # Sometimes we get poorly-encoded data and New Relic chokes
    NewRelic::Agent.disable_all_tracing do
      begin
        # Will fail if no matches. Rely on validation
        list_post_header = email["List-Post"]
        matches = list_post_header.to_s.match(/<mailto:(\S+)@/) if list_post_header
        if matches
          mailing_list_name = matches[1]
        else
          mailing_list_name = email.to.first.to_s
        end

        mailing_list = MailingList.find_by_name(mailing_list_name.try(:strip))

        unless mailing_list
          email_to = email.to.first.to_s rescue nil
          email_from = email[:from] rescue nil
          mail_subject = mail.subject rescue nil
          Rails.logger.warn "No mailing list for '#{mailing_list_name}' header '#{list_post_header}' to '#{email_to}' from '#{email_from}' about '#{mail_subject}'"
          return true
        end

        post.mailing_list = mailing_list

        post.subject = email.subject

        multipart_related = email.parts.detect { |part| part.mime_type == "multipart/related" }
        multipart_alternative = email.parts.detect { |part| part.mime_type == "multipart/alternative" }
        if multipart_related
          # Outlook
          post.body = multipart_related.text_part.try(:decoded)
        elsif multipart_alternative
          # OS X
          post.body = multipart_alternative.text_part.try(:decoded)
        else
          post.body = (email.text_part || email.html_part || email.body).try(:decoded)
        end
        post.body = post.body.encode("UTF-8", :undef => :replace)

        post.from_name = email[:from].display_names.first
        post.from_email = email[:from].addresses.first
        if post.from_name.blank?
          post.from_name = post.from_email_obscured
        end

        post.date = email.date
        post.save!
      rescue => save_error
        Rails.logger.error "Could not save post: #{save_error}"
        begin
          Rails.logger.error email
        rescue
          Rails.logger.error "Could not save email contents"
        end
        if post && post.errors.present?
          Rails.logger.error post.errors.full_messages
        end
        RacingOnRails::Application.exception_notifier.track_exception save_error
        raise
      end
    end
    post
  end
end
