class CreateCohabitantsNotifications < ActiveRecord::Migration
  def change
    create_table :cohabitants_notifications, id: false do |t|
      t.integer :cohabitant_id
      t.integer :notification_id
    end
  end
end
