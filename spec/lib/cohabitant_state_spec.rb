require 'spec_helper'
require_relative '../../lib/cohabitant_state.rb'

describe 'CohabitantState' do
  describe '#info' do
    let(:activated_cohabitant) { Factory(:activated_cohabitant) }
    let(:deactivated_cohabitant) { Factory(:deactivated_cohabitant) }

    let(:activated_state_info) { CohabitantState.new(activated_cohabitant).info }
    let(:deactivated_state_info) { CohabitantState.new(deactivated_cohabitant).info }

    it 'sends correct css for flash for activated cohabitant' do
      activated_state_info[:css].must_equal 'success'
    end

    it 'sends correct css for flash for deactivated cohabitant' do
      deactivated_state_info[:css].must_equal 'info'
    end

    it 'sends correct adj for activated cohabitant' do
      activated_state_info[:adj].must_equal 'reactivated'
    end

    it 'sends correct adj for deactivated cohabitant' do
      deactivated_state_info[:adj].must_equal 'deactivated'
    end
  end
end
