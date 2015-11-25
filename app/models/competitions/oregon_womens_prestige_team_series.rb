module Competitions
  class OregonWomensPrestigeTeamSeries < Competition
    include Competitions::OregonWomensPrestigeSeriesModules::Common

    default_value_for :categories, true
    default_value_for :category_names, [ "Team" ]
    # Decreasing points to 20th place, then 2 points for 21st through 100th
    default_value_for :point_schedule, [ 100, 80, 70, 60, 55, 50, 45, 40, 35, 30, 25, 20, 18, 16, 14, 12, 10, 8, 6, 4 ] + ([ 2 ] * 80)
    default_value_for :results_per_race, 3

    def team?
      true
    end

    def source_events?
      true
    end

    def source_events
      (OregonWomensPrestigeSeries.find_for_year(year) || OregonWomensPrestigeSeries.create).source_events
    end

    def source_results_query(race)
      # Only consider results with categories that match +race+'s category
      if categories?
        super.where("races.category_id in (?)", categories_for(race))
      else
        super
      end
    end

    def after_source_results(results, race)
      results = results.reject do |result|
        result["category_id"].in?(cat_4_category_ids) && result["event_id"].in?(cat_123_only_event_ids)
      end

      # Ignore BAR points multiplier. Leave query "universal".
      set_multiplier results
      results
    end

    def categories_for(race)
      if OregonWomensPrestigeSeries.find_for_year
        categories = Category.where(name: OregonWomensPrestigeSeries.find_for_year.category_names)
        categories = categories + categories.map(&:descendants).to_a.flatten
      else
        []
      end
    end

    def cat_4_category_ids
      if @cat_4_category_ids.nil?
        categories = Category.where(name: "Category 4 Women")
        @cat_4_category_ids = categories.map(&:id) + categories.map(&:descendants).to_a.flatten.map(&:id)
      end
      @cat_4_category_ids
    end
  end
end
