class Ability
  include CanCan::Ability

  def initialize(user)
  
		user ||= User.new # guest user (not logged in)
		
		if user.role? :admin
			can :manage, :all
			
		elsif user.role? :user  
  		can :create, Comment
  		can :show, Comment
  		
  		can :create, Article
  		can :read, Article
  		can :manage, Article do |a|
  		  user.id == a.user_id
		  end
		  
  		can :show, User
  		can :welcome, User
  		can :update, User do |u|
  		  user == u
  		end
 
		else 
		 	can :read, Article
  		can :show, User
  		can :show, Comment
		end
		
  end
  
end
