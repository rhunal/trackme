class Country < ApplicationRecord
  include Import

  has_many :cities, foreign_key: :country_name, primary_key: :name, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  before_validation do
    self.name = self.name.try(:squish).try(:upcase)
  end
end
