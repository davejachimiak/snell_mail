class AddIndecesToForeignKeys < ActiveRecord::Migration
  def change
    add_index :cohabitants_notifications, :cohabitant_id
    add_index :cohabitants_notifications, :notification_id
    add_index :notifications, :user_id
  end
end
