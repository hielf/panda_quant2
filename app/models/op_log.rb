class OpLog < ApplicationRecord
  validates_lengths_from_database
  belongs_to :user

end
