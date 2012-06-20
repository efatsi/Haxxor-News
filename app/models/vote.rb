class Vote < ActiveRecord::Base
  attr_accessible :direction, :user_id, :votable_id, :votable_type
end
