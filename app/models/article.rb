class Article < ActiveRecord::Base
  
  delegate :username, :to => :user
  
  before_validation :adjust_link
  
  attr_accessible :link, :points, :title, :user_id
  
  # Relationships
  belongs_to :user
  has_many :comments, :as => :commentable
  
  # Validations
  validates_presence_of :title, :link, :user_id
  validates_format_of :link, :with => /^(http|https):\/\/([a-z0-9]*[\-\.])?([a-z0-9]+*\.[a-z]{2,5})(:[0-9]{1,5})?(\/.*)?$/
  
  # Methods
  
  def self.search(search, page)
  	paginate :per_page => 20, :page => page, :conditions => ['title || link like ?', "%#{search}%"]
	end
	
	# This method is in comments as well, would like to condense this
	def comment_count
	  count = comments.length
	  comments.each do |c|
	    count += c.comment_count
	  end
	  count
  end
  
  def adjust_link
    if self.link.match(/^(http|https):\/\/([a-z0-9]*[\-\.])?([a-z0-9]+*\.[a-z]{2,5})(:[0-9]{1,5})?(\/.*)?$/).nil? and !self.link.nil?
      self.link = "http://" + self.link
    end    
  end
  
	def short_link
	  link.gsub(/\Ahttps?:\/\/(www.)?/, '').gsub(/\/.*/, '')
  end
  
end
