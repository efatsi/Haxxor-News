class Comment < ActiveRecord::Base
  
  include HaxxorNews::VoteConnector
  
  delegate :username, :to => :user
  
  attr_accessible :commentable_id, :commentable_type, :content, :user_id
  
  # Relationships
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :votes, :as => :votable, :dependent => :destroy
  
  # Validations
  validates_presence_of :content, :user_id, :commentable_id, :commentable_type
  
  # Methods
  def update_count(amount)
    self.comment_count += amount
    self.save!
    self.commentable.update_count(amount)
  end

  
  # Scope
  scope :reverse_chronological, :order => 'created_at ASC'
end
