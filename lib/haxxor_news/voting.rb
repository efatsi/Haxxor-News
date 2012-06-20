module HaxxorNews
  module Voting
    
    extend ActiveSupport::Concern

    included do
      before_filter :assign_object, :only => [:upvote, :downvote]
    end
    
    def upvote
      vote("up")
    end
    
    def downvote
      vote("down")   
    end
    
    def vote(direction)
      @object.points += (direction == "up" ? 1 : -1)
      @object.save
      Vote.create(:user_id => current_user.id, :votable_type => @class_type, :votable_id => params[:id], :direction => direction)
      redirect_to :back
    end
    
    def assign_object
      @class_type = controller_name.classify
      @object = @class_type.constantize.find(params[:id])
    end
    
  end
end


