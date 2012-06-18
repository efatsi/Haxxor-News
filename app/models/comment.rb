class Comment < ActiveRecord::Base
  
  delegate :username, :to => :user
  
  attr_accessible :commentable_id, :commentable_type, :content, :user_id
  
  # Relationships
  belongs_to :commentable, :polymorphic => true, :dependent => :destroy
  belongs_to :user
  has_many :comments, :as => :commentable
  
  # Validations
  validates_presence_of :content, :user
  
  # Methods
  def update_count
    parent = self.get_parent
    parent.update_count
  end
  
	def count_comments
	  count = comments.length
	  comments.each do |c|
	    count += c.count_comments
	  end
	  count
  end
  
end
