class AddIndecesToForeignKeys < ActiveRecord::Migration
  def change
    add_index :cohabitants_notifications, [:cohabitant_id, :notification_id], name: :c_n_index
    add_index :cohabitants_notifications, [:notification_id, :cohabitant_id], name: :n_c_index
    add_index :notifications, :user_id
  end
end
