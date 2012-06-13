class User < ActiveRecord::Base
  
  has_secure_password
  attr_accessible :user_name, :password, :password_confirmation, :role
  
  # Relationships
  has_many :articles
	
	# Validations
	validates_presence_of :user_name, :password, :password_confirmation, :role
	
	def self.authenticate(user_name, password)
		find_by_user_name(user_name).try(:authenticate, password)
	end
		
	def self.find_by_user_name(user_name)
		where(:user_name => user_name).first
	end
	
  ROLES = [['User', 'user'],['Administrator', 'admin']]
  
  
  # in any controllers you want, add
  #     before_filter :check_login, :except => [:index, :show]
    
  
  
  
end
