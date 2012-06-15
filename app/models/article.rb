class Article < ActiveRecord::Base
  
  delegate :username, :to => :user
  
  # before_validation :fill_user
  attr_accessible :link, :points, :title, :user_id
  
  # Relationships
  belongs_to :user
  has_many :comments, :as => :commentable
  
  # Validations
  validates_presence_of :title, :link, :user_id
  
  # Methods
  
  # This did not work :(
  # def fill_user
  #   curr_user = User.find(session[:user_id])
  #   self.user_id = curr_user.id
  # end
  
  def self.search(search, page)
  	paginate :per_page => 20, :page => page, :conditions => ['title || link like ?', "%#{search}%"]
	end
	
	def comment_count
	  count = comments.length
	  comments.each do |c|
	    count += c.comment_count
	  end
	  count
  end
	
  
end
