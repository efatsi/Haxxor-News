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
    
    
    private
    
    def vote(direction)
      @votable.create_vote_by(current_user, direction)
      redirect_to :back
    end
    
    def assign_object
      class_type = controller_name.classify
      @votable = class_type.constantize.find(params[:id])
    end
    
  end
end


