class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :cohabitant_id

      t.timestamps
    end
  end
end
