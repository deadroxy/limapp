class User < ActiveRecord::Base
  
  attr_accessible :first_name, :last_name, :username, :dob
  has_one :soundtrack
  
end
