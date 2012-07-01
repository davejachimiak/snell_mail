class RemoveCohabitantsNotificationsTable < ActiveRecord::Migration
  def create
    drop_table :cohabitants_notifications
  end
end
