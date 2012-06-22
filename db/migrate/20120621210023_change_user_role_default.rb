class ChangeUserRoleDefault < ActiveRecord::Migration
  def change
    change_column_default(:users, :role, "member")
  end
end
