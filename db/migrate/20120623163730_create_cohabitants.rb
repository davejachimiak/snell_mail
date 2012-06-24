class CreateCohabitants < ActiveRecord::Migration
  def change
    create_table :cohabitants do |t|
      t.string :department
      t.string :location
      t.string :contact_name
      t.string :contact_email

      t.timestamps
    end
  end
end
