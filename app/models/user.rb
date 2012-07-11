class User < ActiveRecord::Base

  ROLES = [['Member', 'member'],['Administrator', 'admin']]
  before_create { generate_token(:auth_token) }
  
  has_secure_password
  attr_accessible :username, :password, :password_confirmation, :role, :about, :email
  
  # Relationships
  has_many :articles, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :votes, :dependent => :destroy
	
	# Validations
	validates_presence_of :password, :on => :create
	validates_confirmation_of :password, :if => :password?
	
	validates_presence_of :role, :on => :create
	validates_presence_of :username
	validates_uniqueness_of :username
	validates_inclusion_of :role, :in => ["admin", "member"]
	
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
  
  def can_manage?(resource)
    id == resource.user_id && just_created?(resource)
  end

  def just_created?(resource)
    resource.created_at > 5.minutes.ago
  end
  
  def attempt_password_change(params)
    if User.authenticate(self.username, params[:password][:old_password]) == self 
      
      self.password = params[:password][:new_password] 
      self.password_confirmation = params[:password][:new_password_confirmation] 
      if password == ""
        :blank
      elsif self.save  
        :success
      elsif password != password_confirmation
        :mismatch
      else 
        :failed
      end 
    else 
      :old_password_incorrect 
    end  
  end
  
  def password?
    password.present?
  end
  
end
