class Variety < ActiveRecord::Base
  belongs_to :winery

  attr_accessible :name
end
