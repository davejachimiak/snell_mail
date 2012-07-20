class AddActivatedColumnForCohabitants < ActiveRecord::Migration
  def change
    add_column :cohabitants, :activated, :boolean, default: true
  end
end
