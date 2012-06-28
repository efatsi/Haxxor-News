class Article < ActiveRecord::Base
  
  URI_REGEX = /\A(http|https):\/\/([a-z0-9]*[\-\.])?([a-z0-9]*\.[a-z]{2,5})(:[0-9]{1,5})?(\/.*)?\z/
  
  delegate :username, :to => :user
  
  before_validation :adjust_link
  
  attr_accessible :link, :points, :title, :user_id
  
  # Relationships
  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :votes, :as => :votable, :dependent => :destroy
  
  # Validations
  validates_presence_of :title, :link, :user_id
  validates_format_of :link, :with => URI_REGEX
  
  # Methods
  def self.search(search, page)
    user_ids = User.find(:all, :conditions => ['username like ?', "%#{search}%"]).collect { |user| user.id }
	  paginate :per_page => 20, :page => page, :conditions => ['title || link like ? or user_id IN (?)', "%#{search}%", user_ids]
	end
	
	def update_count(amount)
	  self.comment_count += amount
	  self.save!
  end
  
  def adjust_link
    if !self.link.nil? and self.link.match(URI_REGEX).nil?
      self.link = "http://" + self.link
    end    
  end
  
	def short_link
	  link.gsub(/\Ahttps?:\/\/(www.)?/, '').gsub(/\/.*/, '')
  end

  def self.voted_on_by(user)
    self.joins("LEFT OUTER JOIN votes ON votes.votable_id = #{self.to_s.downcase}s.id WHERE votes.votable_type = '#{self.to_s}' AND votes.user_id = #{user.id}")
  end

  def self.upvoted_by(user)
    self.joins("LEFT OUTER JOIN votes ON votes.votable_id = #{self.to_s.downcase}s.id WHERE votes.votable_type = '#{self.to_s}' AND votes.user_id = #{user.id} AND votes.direction = 'up'")
  end
  
  # Scopes
  scope :chronological, :order => 'created_at DESC'
  
end
