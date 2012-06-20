class Vote < ActiveRecord::Base
  attr_accessible :direction, :user_id, :votable_id, :votable_type
  
  validates_presence_of :direction, :user_id, :votable_id, :votable_type
  
  belongs_to :user
  belongs_to :votable, :polymorphic => true
  
end
