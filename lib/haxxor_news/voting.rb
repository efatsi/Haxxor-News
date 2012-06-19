module HaxxorNews
  module Voting
    
    def upvote
      @object = assign_object
      @object.points += 1
      @object.save
      redirect_to :back
    end
    
    def downvote
      @object = assign_object
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


