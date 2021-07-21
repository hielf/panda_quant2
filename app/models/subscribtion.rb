class Subscribtion < ApplicationRecord
  validates_lengths_from_database
  belongs_to :user

  scope :tryouts, -> { where(:package_type => '新手礼包') }
  scope :today, -> { where("created_at >= ?", Date.today) }

end
