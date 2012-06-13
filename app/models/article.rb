class Article < ActiveRecord::Base
  attr_accessible :date_added, :link, :points, :title, :user_id
  
  def show_user
    u = self.get_user
    u.proper_name
  end
  
  def get_user
    User.find(self.user_id)
  end
  
end
