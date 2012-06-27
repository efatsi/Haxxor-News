class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :role, :default => "member"
      t.string :about
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
