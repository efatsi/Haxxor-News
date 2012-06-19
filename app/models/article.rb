class Article < ActiveRecord::Base
  
  URI_REGEX = /\A(http|https):\/\/([a-z0-9]*[\-\.])?([a-z0-9]+*\.[a-z]{2,5})(:[0-9]{1,5})?(\/.*)?\z/
  
  delegate :username, :to => :user
  
  before_validation :adjust_link
  
  attr_accessible :link, :points, :title, :user_id
  
  # Relationships
  belongs_to :user
  has_many :comments, :as => :commentable
  
  # Validations
  validates_presence_of :title, :link, :user_id
  validates_format_of :link, :with => URI_REGEX
  
  # Methods
  def self.search(search, page)
    user_ids = User.find(:all, :conditions => ['username like ?', "%#{search}%"]).collect { |user| user.id }
	  paginate :per_page => 20, :page => page, :conditions => ['title || link like ? or user_id IN (?)', "%#{search}%", user_ids]
	end
	
	def update_count
	  self.comment_count += 1
	  self.save!
  end
  
  def adjust_link
    if self.link.match(URI_REGEX).nil? and !self.link.nil?
      self.link = "http://" + self.link
    end    
  end
  
	def short_link
	  link.gsub(/\Ahttps?:\/\/(www.)?/, '').gsub(/\/.*/, '')
  end
  
  # Scopes
  scope :chronological, :order => 'created_at DESC'
  
end
