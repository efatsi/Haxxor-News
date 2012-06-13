class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.integer :commentable_id
      t.strin :commentable_type
      t.integer :user_id
      t.datetime :date

      t.timestamps
    end
  end
end
