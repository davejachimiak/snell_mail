class ChangeUserWantsUpdateColumnToDefaultToTrue < ActiveRecord::Migration
  def change
    change_column :users, :wants_update, :boolean, default: true
  end
end
