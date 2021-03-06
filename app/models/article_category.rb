# frozen_string_literal: true

# Homepage Article Category
class ArticleCategory < ApplicationRecord
  acts_as_tree order: "position"
  include ActsAsTree::Validation

  has_many :articles, -> { order("position desc") }
end
