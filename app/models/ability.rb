class Ability
  include CanCan::Ability

  def initialize(user)
  
		user ||= User.new # guest user (not logged in)
		
		if user.role? :admin
			can :manage, :all
		elsif user.role? :user
  		can :manage, :all
		else
		 	can :read, Article
		end
  end
  
end
