class StockAnalyse < ApplicationRecord
  has_many :push_notifications

  scope :today, -> { where("created_at >= ?", Date.today) }
end
