require 'spec_helper'
require_relative './../../lib/snell_mail/notification_confirmation_parser.rb'

describe 'NotificationConfirmationParser' do
  let(:new_parser) { Proc.new { |departments| SnellMail::NotificationConfirmationParser.new(departments) } }

  after do
    Cohabitant.all.each { |cohabitant| cohabitant.destroy } if Cohabitant.any?
  end

  describe 'new instance' do
    it 'requires departments as an argument' do
      it = Proc.new { SnellMail::NotificationConfirmationParser.new }
      it.must_raise ArgumentError
    end
  end
  
  describe '#confirmation' do
    it 'is responsive' do
      it = SnellMail::NotificationConfirmationParser.new(nil)
      it.must_respond_to :confirmation
    end
    
    describe 'with one department' do
      it 'returns neccessary text' do
        department = [FactoryGirl.create(:cohabitant).department]
        it = new_parser.call(department)

        it.confirmation.must_equal('Cool Factory was ')
      end
    end

    describe 'with two departments' do
      it 'returns neccessary text' do
        departments = [FactoryGirl.create(:cohabitant).department,
                       FactoryGirl.create(:cohabitant_3).department]
        it = new_parser.call(departments)

        it.confirmation.must_equal('Cool Factory and Face Surgery were ')
      end
    end

    describe 'with many departments' do
      it "returns necessary text" do
        departments = [FactoryGirl.create(:cohabitant).department,
                       FactoryGirl.create(:cohabitant_2).department,
                       FactoryGirl.create(:cohabitant_3).department]
        it = new_parser.call(departments)

        it.confirmation.must_equal('Cool Factory, Jargon House, ' +
                                   'and Face Surgery were ')
      end
    end
  end
end
