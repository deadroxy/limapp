class Soundtrack < ActiveRecord::Base
  belongs_to :user
  has_many :tracks

  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :tracks  
end
