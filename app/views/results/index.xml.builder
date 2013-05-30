xml.instruct!
xml.events do
  (@weekly_series + @events + @competitions).each do |event|
    xml.event do
      xml.id event.id
      xml.name event.full_name
      xml.date event.date
    end
  end
end