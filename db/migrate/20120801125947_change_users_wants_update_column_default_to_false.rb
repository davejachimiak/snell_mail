class ChangeUsersWantsUpdateColumnDefaultToFalse < ActiveRecord::Migration
  def change
    change_column :users, :wants_update, :boolean, default: false
  end
end
