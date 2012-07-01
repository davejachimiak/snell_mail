class CreateCohabitantsNotifications < ActiveRecord::Migration
  def change
    create_table :cohabitants_notifications, :id => false do |t|
      t.string :cohabitant_id, :null => false
      t.string :notification_id, :null => false
    end
  end
end