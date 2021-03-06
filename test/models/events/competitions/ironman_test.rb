# frozen_string_literal: true

require File.expand_path("../../../../test_helper", __FILE__)

module Competitions
  # :stopdoc:
  class IronmanTest < ActiveSupport::TestCase
    test "count single day events" do
      old_team = FactoryBot.create(:team, name: "Old Team")
      person = FactoryBot.create(:person, team: old_team)
      series = Series.create!
      senior_men = FactoryBot.create(:category)
      series.races.create!(category: senior_men).results.create(place: "1", person: person)

      Ironman.any_instance.expects(:expire_cache).at_least_once
      Ironman.calculate!

      ironman = Ironman.find_for_year
      assert_equal(0, ironman.races.first.results.count, "Should have no Ironman result for a Series result")

      event = series.children.create!
      event.races.create!(category: senior_men).results.create(place: "1", person: person, team_name: "Source Result Team")

      # Change team
      team = FactoryBot.create(:team, name: "Current Team")
      person.team = team
      person.save!

      Ironman.calculate!

      ironman.reload
      assert_equal(1, ironman.races.first.results.count, "Should have one Ironman result for a SingleDayEvent result")
      assert_equal(1, ironman.races.first.results.first.scores.count, "Should have one Ironman score for a SingleDayEvent result")

      # Check that we can calculate again
      Ironman.calculate!

      ironman.reload
      assert_equal(1, ironman.races.first.results.count, "Should have one Ironman result for a SingleDayEvent result")
      assert_equal(1, ironman.races.first.results.first.scores.count, "Should have one Ironman score for a SingleDayEvent result")
      assert_equal team, ironman.races.first.results.first.team, "Should use person's current team, not source result team"
    end

    test "count child events" do
      person = FactoryBot.create(:person)
      event = SingleDayEvent.create!
      child = event.children.create!
      senior_men = FactoryBot.create(:category)
      child.races.create!(category: senior_men).results.create(place: "1", person: person)
      assert(child.ironman?, "Child event should count towards Ironman")

      Ironman.calculate!

      ironman = Ironman.find_for_year
      assert_equal(1, ironman.races.first.results.count, "Should have one Ironman result for a child Event result")
      assert_equal(1, ironman.races.first.results.first.scores.count, "Should have one Ironman score for a child Event result")
    end

    test "skip anything other than single day event" do
      person = FactoryBot.create(:person)
      event = FactoryBot.create(:time_trial_event)
      senior_men = FactoryBot.create(:category)
      event.races.create!(category: senior_men).results.create(place: "99", person: person)
      combined_results = CombinedTimeTrialResults.create!(parent: event)
      assert(!combined_results.ironman?, "CombinedTimeTrialResults event should not count towards Ironman")

      Ironman.calculate!

      ironman = Ironman.find_for_year
      assert_equal(1, ironman.races.first.results.count, "Should have one Ironman result for a TT result")
      assert_equal(1, ironman.races.first.results.first.scores.count, "Should have one Ironman score for a TT result")
    end

    test "parent event results do not count" do
      person = FactoryBot.create(:person)
      senior_men = FactoryBot.create(:category)
      series = Series.create!
      series.races.create!(category: senior_men).results.create(place: "1", person: person)

      # Only way to exclude these results is to manually set ironman? to false
      event = series.children.create!(ironman: false)
      event.races.create!(category: senior_men).results.create(place: "1", person: person)

      child = event.children.create!
      child.races.create!(category: senior_men).results.create(place: "1", person: person)

      Ironman.calculate!

      ironman = Ironman.find_for_year
      assert_equal(1, ironman.races.first.results.count, "Should have one Ironman result for a child Event result, but no others")
      assert_equal(1, ironman.races.first.results.first.scores.count, "Should have one Ironman score for a child Event result, but no others")
    end

    # TODO: Move to superclass once superclass uses them
    test "source results no results" do
      ironman = Ironman.create!
      assert_equal [], ironman.source_results(ironman.races.first).to_a, "source_results"
    end

    test "source results" do
      person = FactoryBot.create(:person, name: "Greg Lemond", member_from: Date.new(2005, 8, 1), member_to: Date.new(2010, 12, 31))
      source_result = FactoryBot.create(:result, place: "12", person: person)
      ironman = Ironman.create!
      expected = {
        "id" => 1,
        "multiplier" => 1,
        "age" => nil,
        "category_ability" => source_result.race.category.ability_begin,
        "category_ages_begin" => 0,
        "category_ages_end" => ::Categories::MAXIMUM,
        "category_equipment" => nil,
        "category_gender" => "M",
        "event_bar_points" => 1,
        "date" => Time.zone.today,
        "discipline" => "Road",
        "type" => "SingleDayEvent",
        "gender" => nil,
        "member_from" => Date.new(2005, 8, 1),
        "member_to" => Date.new(2010, 12, 31),
        "parent_bar_points" => nil,
        "parent_parent_bar_points" => nil,
        "person_gender" => nil,
        "person_name" => "Greg Lemond",
        "points_factor" => nil,
        "race_bar_points" => nil,
        "participant_id" => 1,
        "event_id" => 1,
        "place" => "12",
        "points" => 0.0,
        "race_id" => 1,
        "category_name" => source_result.race.name,
        "year" => RacingAssociation.current.year,
        "team_member" => 1,
        "team_name" => source_result.team.name,
        "visible" => 1
      }
      assert_equal [expected], ironman.source_results(ironman.races.first).to_a, "source_results"
    end

    test "create competition results for" do
      person = FactoryBot.create(:person)
      result1 = FactoryBot.create(:result, person: person)
      result2 = FactoryBot.create(:result, person: person)

      Struct.new("TestResult", :place, :participant_id, :preliminary, :points, :scores)
      Struct.new("TestScore", :points, :source_result_id, :notes)
      scores = [Struct::TestScore.new(1, result1.id), Struct::TestScore.new(1, result2.id)]
      calculated_results = [Struct::TestResult.new(1, person.id, false, 2, scores)]

      ironman = Ironman.create!
      ironman.create_competition_results_for(calculated_results, ironman.races.first)
      assert_equal 3, Result.count
      assert_equal 2, Competitions::Score.count

      ironman_result = ironman.races.first.results.first
      assert_equal "1", ironman_result.place, "place"
      assert_equal person.id, ironman_result.person_id, "person_id"
      assert_nil ironman_result.team_id, "team_id"
      assert_equal ironman_result.event, ironman_result.event, "event"
      assert_equal ironman.races.first, ironman_result.race, "race"
      assert_equal true, ironman_result.competition_result?, "competition_result"
      assert_equal 2, ironman_result.points, "points"
    end

    test "create competition results for no results" do
      ironman = Ironman.create!
      ironman.create_competition_results_for([], ironman.races.first)
      assert_equal 0, Result.count
      assert_equal 0, Competitions::Score.count
    end

    test "team ids by person id hash" do
      ironman = Ironman.create!
      assert_equal({}, ironman.team_ids_by_participant_id_hash([]))
    end

    test "team ids by person id hash no results" do
      team = FactoryBot.create(:team)
      person = FactoryBot.create(:person, team: team)
      ironman = Ironman.create!
      Struct.new("TestResult2", :participant_id)
      assert_equal({ person.id => team.id }, ironman.team_ids_by_participant_id_hash([Struct::TestResult2.new(person.id)]))
    end

    test "create score" do
      ironman = Ironman.create!
      source_result = FactoryBot.create(:result)
      competition_result = ironman.races.first.results.create!
      score = ironman.create_score(competition_result, source_result.id, 12, "")
      assert_equal source_result.id, score.source_result_id, "source_result_id"
      assert_equal competition_result.id, score.competition_result_id, "competition_result_id"
      assert_equal 12, score.points, "points"
    end
  end
end
