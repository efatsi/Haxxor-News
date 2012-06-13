class User < ActiveRecord::Base
  
  has_secure_password
  attr_accessible :username, :password, :password_confirmation, :role
  
  # Relationships
  has_many :articles
	
	# Validations
	validates_presence_of :username, :password, :password_confirmation, :role
	
	def self.authenticate(username, password)
		find_by_username(username).try(:authenticate, password)
	end
		
	def self.find_by_username(username)
		where(:username => username).first
	end
	
  ROLES = [['User', 'user'],['Administrator', 'admin']]
  
  
  # in any controllers you want, add
  #     before_filter :check_login, :except => [:index, :show]
    
  
  
  
end
