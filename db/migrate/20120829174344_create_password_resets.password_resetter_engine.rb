# This migration comes from password_resetter_engine (originally 20120829163145)
class CreatePasswordResets < ActiveRecord::Migration
  def change
    create_table :password_resets do |t|
      t.string :identifier
      t.string :password
      t.string :password_confirmation

      t.timestamps
    end
  end
end
