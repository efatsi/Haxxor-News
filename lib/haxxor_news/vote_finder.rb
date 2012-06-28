module HaxxorNews
  module VoteFinder
        
    extend ActiveSupport::Concern
    
    module ClassMethods
      def voted_on_by(user)
        self.joins("LEFT OUTER JOIN votes ON votes.votable_id = #{self.to_s.downcase}s.id WHERE votes.votable_type = '#{self.to_s}' AND votes.user_id = #{user.id}")
      end

      def upvoted_by(user)
        self.joins("LEFT OUTER JOIN votes ON votes.votable_id = #{self.to_s.downcase}s.id WHERE votes.votable_type = '#{self.to_s}' AND votes.user_id = #{user.id} AND votes.direction = 'up'")
      end
    end
  
  end
end


