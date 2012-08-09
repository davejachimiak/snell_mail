require 'spec_helper'

describe CohabitantsHelper do
  let(:activated_cohabitant) { Factory(:activated_cohabitant) }
  let(:deactivated_cohabitant) { Factory(:deactivated_cohabitant) }

  after do
    Cohabitant.all.each { |cohabitant| cohabitant.destroy } if Cohabitant.any?
  end

  it '::toggle_activated_button is responsive' do
    self.must_respond_to :toggle_activated_button
  end 

  it '::toggle_activated_button returns deactivate button if cohabitant is activated' do
    button = button_to 'deactivate', toggle_activated_path(activated_cohabitant),
             title: "Deactivate #{activated_cohabitant.department}", class: "btn btn-inverse"

    toggle_activated_button(activated_cohabitant).must_match button
  end

  it '::toggle_activated_button returns activate button if cohabitant is deactivated' do
    button = button_to 'activate', toggle_activated_path(deactivated_cohabitant),
             title: "Activate #{deactivated_cohabitant.department}", class: "btn"

    toggle_activated_button(deactivated_cohabitant).must_equal button
  end
end
