class RemoveOutdatedTables < ActiveRecord::Migration
  def change
    %w{ duplicates_racers engine_schema_info historical_names images news_items promoters racers standings users }.each do |name|
      if table_exists?(name)
        drop_table name
      end
    end
  end
end
