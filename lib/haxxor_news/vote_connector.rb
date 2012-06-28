module HaxxorNews
  module VoteConnector
        
    extend ActiveSupport::Concern
    
    module ClassMethods
      def voted_on_by(user)
        self.joins("LEFT OUTER JOIN votes ON votes.votable_id = #{self.to_s.downcase}s.id WHERE votes.votable_type = '#{self.to_s}' AND votes.user_id = #{user.id}")
      end

      def upvoted_by(user)
        self.joins("LEFT OUTER JOIN votes ON votes.votable_id = #{self.to_s.downcase}s.id WHERE votes.votable_type = '#{self.to_s}' AND votes.user_id = #{user.id} AND votes.direction = 'up'")
      end
    end
    
    module InstanceMethods
      def create_vote_by(user, direction)
        self.points += (direction == "up" ? 1 : -1)
        self.save
        Vote.create(:user_id => user.id, :votable_type => self.class.to_s, :votable_id => self.id, :direction => direction)
      end
    end
  
  end
end


