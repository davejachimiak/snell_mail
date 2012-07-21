class Cohabitant < ActiveRecord::Base
  validates_presence_of :department, :location, :contact_name, :contact_email
  validates :contact_email, format: { with: User::VALID_EMAIL_REGEX }

  attr_accessible :department, :location, :contact_name, :contact_email,
                  :activated

  has_and_belongs_to_many :notifications

  def deactivate!
    self.update_attributes(activated: false)
  end

  def activate!
    self.update_attributes(activated: true)
  end

  class << self
    def parse_for_notification(cohabitants)
      if cohabitants.count > 1
        parse_many_cohabitants(cohabitants)
      else
        cohabitants[0].department + ' was '
      end
    end
    
    def parse_many_cohabitants(cohabitants)
      cohabitants.map do |cohabitant|
        if cohabitant == cohabitants.last
          last_of_many_cohabitants(cohabitant)
        elsif cohabitants.count == 2
          first_of_two_cohabitants(cohabitant)
        else
          "#{cohabitant.department}, "
        end
      end.join
    end
    
    def last_of_many_cohabitants(cohabitant)
      "and #{cohabitant.department} were "
    end

    def first_of_two_cohabitants(cohabitant)
      "#{cohabitant.department} " 
    end
  end
end
