require 'spec_helper'
require_relative '../../lib/snell_mail/cohabitant_activation_state.rb'

describe 'CohabitantActivationState' do
  describe '#message' do
    let(:activated_cohabitant) { Factory(:activated_cohabitant) }
    let(:deactivated_cohabitant) { Factory(:deactivated_cohabitant) }
    let(:activated_state_message) { SnellMail::CohabitantActivationState.new(activated_cohabitant).message }
    let(:deactivated_state_message) { SnellMail::CohabitantActivationState.new(deactivated_cohabitant).message }

    it 'sends correct flash info for activated cohabitant' do
      subject[:flash].must_equal 'success'
    end

    it 'sends correct flash info for deactivated cohabitant' do
      subject.toggle_activated!
      subject[:flash].must_equal 'info'
    end
  end
end
