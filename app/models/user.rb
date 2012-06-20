class User < ActiveRecord::Base

  ROLES = [['User', 'user'],['Administrator', 'admin']]
  
  has_secure_password
  attr_accessible :username, :password, :password_confirmation, :role, :about, :email
  
  # Relationships
  has_many :articles, :dependent => :destroy
	
	# Validations
	validates_presence_of :password, :password_confirmation, :role, :on => :create
	validates_presence_of :username
	validates_uniqueness_of :username
	
	# Methods
  
	def self.authenticate(username, password)
		find_by_username(username).try(:authenticate, password)
	end

  def voted_on(votable)
    voted_on_indexes = Vote.find(:all, :conditions => ['user_id = ? and votable_type = ?', 1, votable.class.to_s]).collect { |vote| vote.votable_id }
    voted_on_indexes.include?(votable.id)
  end
	
	def role?(authorized_role)
		return false if role.nil?
		role.to_sym == authorized_role
	end
  
end
