class Ability
  include CanCan::Ability

  def initialize(user)
  
		user ||= User.new # guest user (not logged in)
		
		if user.role?(:admin)
			can :manage, :all
			
		elsif user.role?(:member) && !user.id.nil?
  		can :create, Comment
  		can :show, Comment
  		can :vote, Comment
  		can :manage, Comment do |c|
  		  user.id == c.user_id && user.just_created(c)
		  end
		  cannot :vote, Comment do |c|
  		  Vote.contains?(user, c)
		  end
  		
  		can :create, Article
  		can :read, Article
  		can :vote, Article
  		can :manage, Article do |a|
  		  user.id == a.user_id && user.just_created(a)
		  end
		  cannot :vote, Article do |a|
  		  Vote.contains?(user, a)
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
<<<<<<< HEAD
		 	can :create, User
  		can :show, User
  		can :show, Comment
=======
		 	can :pick_date, Article
		  can :create, User
  		can :read, User
  		can :read, Comment
>>>>>>> stufftopush
		end
		
  end
  
end
