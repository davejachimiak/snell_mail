class RemoveCohabitantIdFromNotifications < ActiveRecord::Migration
  def change
    remove_column :notifications, :cohabitant_id
  end
end
