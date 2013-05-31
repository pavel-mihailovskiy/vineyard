class Winery < ActiveRecord::Base
  has_many :varieties, dependent: :destroy

  attr_accessible :country, :tasting_room, :varieties_attributes

  validates :country, :tasting_room, presence: true

  validates :varieties, associated: true

  accepts_nested_attributes_for :varieties
end
