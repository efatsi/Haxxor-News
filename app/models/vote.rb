class Vote < ActiveRecord::Base
  attr_accessible :direction, :user_id, :votable_id, :votable_type
  
  validates_presence_of :direction, :user_id, :votable_id, :votable_type
  validates_inclusion_of :direction, :in => ["up", "down"]
  
  belongs_to :user
  belongs_to :votable, :polymorphic => true
  
  
  # Methods
  
  def self.contains?(user, votable)
    user.votes.where("votable_type = ? AND votable_id = ?", votable.class.to_s, votable.id).count != 0
  end
  
end
