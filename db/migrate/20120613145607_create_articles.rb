class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :link
      t.datetime :date
      t.integer :user_id
      t.integer :points

      t.timestamps
    end
  end
end
