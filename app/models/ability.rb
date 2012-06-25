class Ability
  include CanCan::Ability

  def initialize(user)
  
		user ||= User.new # guest user (not logged in)
		
		if user.role?(:admin)
			can :manage, :all
			
		elsif user.role?(:member) && !user.id.nil?
  		can :create, Comment
  		can :read, Comment
  		
  		can :create, Article
  		can :read, Article
		 	can :pick_date, Article
  		can :manage, Article do |a|
  		  user.id == a.user_id
		  end
		  
		 	can :create, User
  		can :read, User
  		can :welcome, User # can read the welcome screen
  		can :update, User do |u|
  		  user == u
  		end
    	can :change_password, User do |u|
  		  user == u
  		end
 
		else 
		 	can :read, Article
		 	can :pick_date, Article
		  can :create, User
  		can :read, User
  		can :read, Comment
		end
		
  end
  
end
