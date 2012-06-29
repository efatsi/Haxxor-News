class Ability
  include CanCan::Ability

  def initialize(user)
  
		user ||= User.new # guest user (not logged in)
		
		if user.role? :admin
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
