require 'spec_helper'
require_relative './../../lib/message_subjects.rb'

describe 'MessageSubjects' do

  after do
    Cohabitant.destroy_all if Cohabitant.any?
  end

  describe 'new instance' do
    it 'requires subjects as an argument' do
      it = Proc.new { MessageSubjects.new }
      it.must_raise ArgumentError
    end
  end

  describe '#construct' do
    it 'is responsive' do
      it = MessageSubjects.new(nil)
      it.must_respond_to :construct
    end

    describe 'with one subject' do
      it 'returns neccessary text' do
        department = [Factory(:cohabitant).department]
        it = MessageSubjects.new(department)

        it.construct.must_equal('Cool Factory was ')
      end
    end

    describe 'with two subjects' do
      it 'returns neccessary text' do
        departments = [Factory(:cohabitant).department,
                       Factory(:cohabitant_3).department]
        it = MessageSubjects.new(departments)

        it.construct.must_equal('Cool Factory and Face Surgery were ')
      end
    end

    describe 'with many subjects' do
      it "returns necessary text" do
        departments = [Factory(:cohabitant).department,
                       Factory(:cohabitant_2).department,
                       Factory(:cohabitant_3).department]
        it = MessageSubjects.new(departments)

        it.construct.must_equal('Cool Factory, Jargon House, ' +
                                'and Face Surgery were ')
      end
    end
  end
end
