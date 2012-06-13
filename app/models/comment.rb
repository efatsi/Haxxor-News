class Comment < ActiveRecord::Base
  attr_accessible :commentable_id, :commentable_type, :content, :date, :user_id
end
