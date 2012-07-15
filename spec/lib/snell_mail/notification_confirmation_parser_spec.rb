require 'spec_helper'
require_relative '../../../lib/snell_mail/notification_confirmation_parser.rb'

describe 'CohabitantsForNotificationConfirmation' do
  describe 'new instance' do
    before do
      @it = SnellMail::NotificationConfirmationParser.new
    end
  end
end
