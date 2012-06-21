class User < ActiveRecord::Base

  ROLES = [['Member', 'member'],['Administrator', 'admin']]
  before_create { generate_token(:auth_token) }
  
  
  has_secure_password
  attr_accessible :username, :password, :password_confirmation, :role, :about, :email
  
  # Relationships
  has_many :articles, :dependent => :destroy
	
	# Validations
	validates_presence_of :password, :password_confirmation, :role, :on => :create
	validates_presence_of :username
	validates_uniqueness_of :username
	
	# Methods

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
  
	def self.authenticate(username, password)
		find_by_username(username).try(:authenticate, password)
	end

	
	def role?(authorized_role)
		return false if role.nil?
		role.to_sym == authorized_role
	end
  
end
