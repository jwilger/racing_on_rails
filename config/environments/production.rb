# frozen_string_literal: true

Rails.application.configure do
  require "syslog/logger"

  config.action_controller.action_on_unpermitted_parameters = :raise
  config.action_controller.perform_caching                  = true
  config.action_dispatch.x_sendfile_header                  = "X-Accel-Redirect"
  config.action_mailer.perform_caching                      = false
  config.active_record.dump_schema_after_migration          = false
  config.active_storage.service                             = :local
  config.active_support.deprecation                         = :notify
  config.assets.compile                                     = false
  config.assets.js_compressor                               = :uglifier
  config.cache_classes                                      = true
  config.cache_store                                        = :dalli_store, { pool_size: 5 }
  config.consider_all_requests_local                        = false
  config.eager_load                                         = true
  config.i18n.fallbacks                                     = true
  config.log_formatter = ::Logger::Formatter.new
  config.log_level                                          = :info
  config.log_tags                                           = [ :request_id ]
  config.logger                                             = Syslog::Logger.new("racing_on_rails", Syslog::LOG_LOCAL4)
  config.public_file_server.enabled                         = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.require_master_key                                 = true

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end
end
