module HaxxorNews
  module VoteConnector
        
    extend ActiveSupport::Concern

    def create_vote_by(user, direction)
      self.points += (direction == "up" ? 1 : -1)
      self.save
      Vote.create(:user_id => user.id, :votable  => self, :direction => direction)
    end
    
    module ClassMethods
      def voted_on_by(user)
        self.joins("LEFT OUTER JOIN votes ON votes.votable_id = #{self.table_name}.id WHERE votes.votable_type = '#{self.to_s}' AND votes.user_id = #{user.id}")
      end

      def upvoted_by(user)
        self.joins("LEFT OUTER JOIN votes ON votes.votable_id = #{self.table_name}.id WHERE votes.votable_type = '#{self.to_s}' AND votes.user_id = #{user.id} AND votes.direction = 'up'")
      end
    end

  end
end


