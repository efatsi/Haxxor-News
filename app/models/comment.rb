class Comment < ActiveRecord::Base
  attr_accessible :commentable_id, :commentable_type, :content, :user_id
  
  # Relationships
  belongs_to :commentable, :polymorphic => true, :dependent => :destroy
  belongs_to :user
  has_many :comments, :as => :commentable
  
  # Validations
  validates_presence_of :content, :user
  
  # Methods
  
  def get_user
    User.find(self.user_id)
  end
  
  def show_user
    u = self.get_user
    u.username    
  end


end
