# frozen_string_literal: true

class AddRacesVisible < ActiveRecord::Migration
  def change
    add_column :races, :visible, :boolean, default: true
  end
end
