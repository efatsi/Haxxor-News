class Article < ActiveRecord::Base
  
  include HaxxorNews::VoteConnector
  URI_REGEX = /\A(http|https):\/\/([a-z0-9]*[\-\.])?([a-z0-9]*\.[a-z]{2,5})(:[0-9]{1,5})?(\/.*)?\z/
  YEARS = (Time.now.year-5..Time.now.year).map{|y| y}.reverse
  MONTHS = Hash[["January", "Fubruary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"].zip [1,2,3,4,5,6,7,8,9,10,11,12]]
  DAYS = (1..31).to_a

  delegate :username, :to => :user
  
  before_validation :adjust_link
  
  attr_accessible :link, :points, :title, :user_id, :created_at
  
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

  
  # Scopes
  scope :chronological, order('created_at DESC')
  scope :by_user, lambda { |user_id| where("user_id = ?", user_id) }
  scope :by_rating, order('points DESC, created_at DESC')
  scope :this_day, where('created_at > ?', 1.day.ago)
  scope :this_month, where('created_at > ?', 1.month.ago)
  scope :this_year, where('created_at > ?', 1.year.ago)
  scope :day, lambda { |day, month, year| where("created_at >= ? and created_at < ?", Time.new(year, month, day), Time.new(year, month, day) + 60*60*24) }
  scope :month, lambda { |month, year| where("created_at >= ? and created_at < ?", Time.new(year, month), Time.new(year, month) + 60*60*24*31) }
  scope :year, lambda { |year| where("created_at >= ? and created_at < ?", Time.new(year), Time.new(year+1)) }
  
end
