class Ability
  include CanCan::Ability

  def initialize(user)
  
		user ||= User.new # guest user (not logged in)
		
		if user.role? :admin
			can :manage, :all
			
		elsif user.role?(:member) && !user.id.nil?
  		can :create, Comment
  		can :show, Comment
  		can :vote, Comment do |c|
  		  Vote.does_not_contain?(user, c)
		  end
  		can :manage, Comment do |c|
  		  user.id == c.user_id && user.just_created(c)
		  end
  		
  		can :create, Article
  		can :read, Article
  		can :vote, Article do |a|
  		  Vote.does_not_contain?(user, a)
		  end
  		can :manage, Article do |a|
  		  user.id == a.user_id && user.just_created(a)
		  end
		  
		 	can :create, User
  		can :show, User
  		can :welcome, User
  		can :update, User do |u|
  		  user == u
  		end
 
		else 
		 	can :read, Article
		 	can :create, User
  		can :show, User
  		can :show, Comment
		end
		
  end
  
end
