require 'spec_helper'
require_relative './../../lib/snell_mail/notification_confirmer.rb'

describe 'NotificationConfirmer' do
  let(:new_parser) { Proc.new { |departments| SnellMail::NotificationConfirmer.new(departments) } }

  after do
    Cohabitant.all.each { |cohabitant| cohabitant.destroy } if Cohabitant.any?
  end

  describe 'new instance' do
    it 'requires departments as an argument' do
      it = Proc.new { SnellMail::NotificationConfirmer.new }
      it.must_raise ArgumentError
    end
  end

  describe '#departments_string' do
    it 'is responsive' do
      it = SnellMail::NotificationConfirmer.new(nil)
      it.must_respond_to :departments_string
    end

    describe 'with one department' do
      it 'returns neccessary text' do
        department = [Factory(:cohabitant).department]
        it = SnellMail::NotificationConfirmer.new(department)

        it.departments_string.must_equal('Cool Factory was ')
      end
    end

    describe 'with two departments' do
      it 'returns neccessary text' do
        departments = [Factory(:cohabitant).department,
                       Factory(:cohabitant_3).department]
        it = SnellMail::NotificationConfirmer.new(departments)

        it.departments_string.must_equal('Cool Factory and Face Surgery were ')
      end
    end

    describe 'with many departments' do
      it "returns necessary text" do
        departments = [Factory(:cohabitant).department,
                       Factory(:cohabitant_2).department,
                       Factory(:cohabitant_3).department]
        it = SnellMail::NotificationConfirmer.new(departments)

        it.departments_string.must_equal('Cool Factory, Jargon House, ' +
                                   'and Face Surgery were ')
      end
    end
  end
end
