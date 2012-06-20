class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id
      t.string :votable_type
      t.integer :votable_id
      t.string :direction

      t.timestamps
    end
  end
end
