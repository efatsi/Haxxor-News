class User < ActiveRecord::Base

  ROLES = [['User', 'user'],['Administrator', 'admin']]
  
  has_secure_password
  attr_accessible :username, :password, :password_confirmation, :role, :about, :email
  
  # Relationships
  has_many :articles, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :votes, :dependent => :destroy
	
	# Validations
	validates_presence_of :password, :password_confirmation, :role, :on => :create
	validates_presence_of :username
	validates_uniqueness_of :username
	validates_inclusion_of :role, :in => ["admin", "member"]
	
	# Methods
  
	def self.authenticate(username, password)
		find_by_username(username).try(:authenticate, password)
	end

	def role?(authorized_role)
		return false if role.nil?
		role.to_sym == authorized_role
	end
	
	def just_created(creatable)
	  creatable.created_at > Time.now - 5*60
  end
  
end
