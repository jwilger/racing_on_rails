# frozen_string_literal: true

require File.expand_path("../../../../../test_helper", __FILE__)

module Competitions
  module OregonJuniorCyclocrossSeries
    # :stopdoc:
    class OverallTest < ActiveSupport::TestCase
      test "calculate" do
        series = OregonJuniorCyclocrossSeries::Overall.create!(date: Date.new(2004))
        event = SingleDayEvent.create!(date: Date.new(2004))
        boys_10_12 = Category.find_or_create_by(name: "Boys 10-12")
        person = FactoryBot.create(:person)
        event.races.create!(category: boys_10_12).results.create!(place: 3, person: person)
        series.source_events << event

        OregonJuniorCyclocrossSeries::Overall.calculate!
      end
    end
  end
end
