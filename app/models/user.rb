class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name, :role, :OTHER_id

  def proper_name
    "#{first_name} #{last_name}"
  end
	
	def self.authenticate(email, password)
		find_by_email(email).try(:authenticate, password)
	end
		
	def self.find_by_email(email)
		where(:email => email).first
	end
	
  ROLES = [['User', 'user'],['Administrator', 'admin']]
  
end
