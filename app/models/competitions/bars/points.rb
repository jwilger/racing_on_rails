module Competitions
  module Bars
    module Points
      extend ActiveSupport::Concern

      def point_schedule
        [ 15, 14, 13, 12, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1 ]
      end
    end
  end
end
