class PasswordReset 
  # extend ActiveModel::Naming
  include ActiveModel::Validations
  include ActiveModel::Conversion
  
  attr_accessor :identifier
  
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
  
  def save
    if valid? 
      # user.generate_token(:password_reset_token)
      # user.password_reset_sent_at = Time.zone.now
      # user.save!
      # UserMailer.password_reset(user).deliver
      user.send_password_reset
      true
    else
      false
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