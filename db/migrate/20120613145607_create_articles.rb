class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :link
      t.integer :user_id
      t.integer :comment_count, :default => 0
      t.integer :points, :default => 20

      t.timestamps
    end
  end
end
