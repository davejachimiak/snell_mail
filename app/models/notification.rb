class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :cohabitant
  
  serialize :cohabitant_id
end
