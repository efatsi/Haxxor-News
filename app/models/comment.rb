class Comment < ActiveRecord::Base
  
  include HaxxorNews::VoteConnector
  
  after_create :increment_parent_count
  after_destroy :decrement_parent_count
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
  scope :chronological, :order => 'created_at DESC'
  scope :by_user, (lambda do |user_id| 
    {:conditions => ['user_id = ?', user_id]}
  end)
  
  private
  def increment_parent_count
    parent = self.commentable
    parent.update_count(1)
  end
  
  def decrement_parent_count
    parent = self.commentable
    parent.update_count(-1)
  end
  
  
end
