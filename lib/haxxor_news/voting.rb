module HaxxorNews
  module Voting
    
    extend ActiveSupport::Concern

    included do
      before_filter :assign_object, :only => [:upvote, :downvote]
    end
    
    def upvote
      @object.points += 1
      @object.save
      redirect_to :back
    end
    
    def downvote
      @object.points -= 1
      @object.save
      redirect_to :back      
    end
    
    def assign_object
      class_type = controller_name.classify.constantize
      @object = class_type.find(params[:id])
    end
    
  end
end


