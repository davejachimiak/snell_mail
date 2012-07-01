class CohabitantValidator < ActiveModel::Validator
  attr_reader :current_cohabitants

  def current_cohabitants
    @current_cohabitants ||= Cohabitant.all
  end
  
  def validate(record)
    record.cohabitants.each do |c|
      if !current_cohabitants.include?(c)
        record.errors[:base] << "#{c} isn't a valid cohabitant"
      end
    end
  end
end
