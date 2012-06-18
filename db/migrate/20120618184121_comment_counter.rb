class CommentCounter < ActiveRecord::Migration
  def up
    add_column :articles, :comment_count, :integer, :default => 0

    Article.reset_column_information
    Article.find(:all).each do |a|
      Article.update_counters a.id, :comment_count => a.count_comments
    end
  end

  def down
  remove_column :articles, :comment_count
  end
end
