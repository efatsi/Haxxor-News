class Article < ActiveRecord::Base
  attr_accessible :date, :link, :points, :title, :user_id
  
  # Relationships
  belongs_to :user
  
  # Validations
  validates_presence_of :title, :link, :user_id, :date
  
  
  def show_user
    u = self.get_user
    u.user_name
  end
  
  def get_user
    User.find(self.user_id)
  end
  
end
