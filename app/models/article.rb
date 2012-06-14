class Article < ActiveRecord::Base
  
  # before_validation :fill_user
  attr_accessible :link, :points, :title, :user_id
  
  # Relationships
  belongs_to :user
  has_many :comments, :as => :commentable
  
  # Validations
  validates_presence_of :title, :link, :user_id
  
  # Methods
  # def fill_user
  #   curr_user = User.find(session[:user_id])
  #   self.user_id = curr_user.id
  # end
  
  def get_user
    User.find(self.user_id)
  end
  
  def show_user
    u = self.get_user
    u.username
  end
  
  def self.search(search, page)
  	paginate :per_page => 20, :page => page, :conditions => ['title || link like ?', "%#{search}%"]
	end
  
end
