class AddPointsToComments < ActiveRecord::Migration
  def change
    add_column :comments, :points, :integer, :default => 0
  end
end
