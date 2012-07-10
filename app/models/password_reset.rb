class PasswordReset 
  # extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion
  
  attr_accessor :identifier, :user
  
  validates_presence_of :identifier
  validate :user_exists
  validate :user_has_email_address
  
  def initialize(attributes = {})
    (attributes || {}).each {|k,v| send("#{k}=", v) }
  end
  
  def user
    @user ||= if identifier.present?
      User.where(['username = :identifier OR email = :identifier', :identifier => identifier]).first
    end
  end
  
  def id
    user.password_reset_token
  end
  
  def persisted?
    user.present?
  end
  
  def expired?
    user.password_reset_sent_at < 2.hours.ago
  end
  
  def save
    if valid? 
      user.send_password_reset
      true
    else
      false
    end
  end
  
  def update(params = {})
    if (params.values.include?("") || params.blank?)
      false
    else
      @user.password = params[:password]
      @user.password_confirmation = params[:password_confirmation]
      @user.save
    end
  end
  

  private
  
  def user_exists
    errors.add(:user, "was not found") unless user
  end

  def user_has_email_address
    errors.add(:user, "must have an email address") if user && user.email.blank?
  end
  
end