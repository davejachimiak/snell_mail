ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "minitest/autorun"
require "capybara/rails"
require "active_support/testing/setup_and_teardown"
require "factory_girl_rails"

class IntegrationTest < MiniTest::Spec
  include Rails.application.routes.url_helpers
  include Capybara::DSL
  register_spec_type(/integration$/, self)
end

class HelperTest < MiniTest::Spec
  include ActiveSupport::Testing::SetupAndTeardown
  include ActionView::TestCase::Behavior
  register_spec_type(/Helper$/, self)
end

Turn.config.format = :outline

def create_test_users
  FactoryGirl.create(:user)
  FactoryGirl.create(:non_admin)
end

def create_admin_user
  FactoryGirl.create(:user)
end

def create_non_admin_user
  FactoryGirl.create(:non_admin)
end

def test_sign_in_admin

end

def test_sign_in_non_admin
  visit '/'
  fill_in 'session_email', with: 'new.student@neu.edu'
  fill_in 'session_password', with: 'password'
  click_button 'Sign in'
end
