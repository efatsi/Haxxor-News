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
  
  # This works but I don't think is very clean, outputs a string like "/articles/1"
  def parent_path
    parent_type = commentable_type.downcase + "s"
    parent_id = commentable_id.to_s
    "/" + parent_type + "/" + parent_id
  end

	def comment_count
	  count = comments.length
	  comments.each do |c|
	    count += c.comment_count
	  end
	  count
  end
  
end
