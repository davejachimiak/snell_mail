class AddWantsUpdateToUser < ActiveRecord::Migration
  def change
    add_column :users, :wants_update, :boolean
  end
end
