require "rake/testtask"

namespace :test do
  Rake::TestTask.new(all: ['integration', 'lib', 'models', 'helpers', 'mailers']) do |t|
    t.libs << "spec"
  end

  Rake::TestTask.new(models: "db:test:prepare") do |t|
    t.libs << "spec"
    t.pattern = "spec/models/*_spec*.rb"
  end

  namespace :models do
    Rake::TestTask.new(user: "db:test:prepare") do |t|
      t.libs << "spec"
      t.pattern = "spec/models/user_spec.rb"
    end

    Rake::TestTask.new(cohabitant: "db:test:prepare") do |t|
      t.libs << "spec"
      t.pattern = "spec/models/cohabitant_spec.rb"
    end

    Rake::TestTask.new(notification: "db:test:prepare") do |t|
      t.libs << "spec"
      t.pattern = "spec/models/notification_spec.rb"
    end
  end

  Rake::TestTask.new(mailers: "db:test:prepare") do |t|
    t.libs << "spec"
    t.pattern = "spec/mailers/**/*.rb"
  end

  namespace :mailers do
    Rake::TestTask.new(notification: "db:test:prepare") do |t|
      t.libs << "spec"
      t.pattern = "spec/mailers/notification_mailer_spec.rb"
    end
  end

  Rake::TestTask.new(helpers: "db:test:prepare") do |t|
    t.libs << "spec"
    t.pattern = "spec/helpers/**/*.rb"
  end

  namespace :helpers do
    Rake::TestTask.new(application: "db:test:prepare") do |t|
      t.libs << "spec"
      t.pattern = "spec/helpers/application_helper_spec.rb"
    end

    Rake::TestTask.new(cohabitants: "db:test:prepare") do |t|
      t.libs << "spec"
      t.pattern = "spec/helpers/cohabitants_helper_spec.rb"
    end

	Rake::TestTask.new(notifications: "db:test:prepare") do |t|
      t.libs << "spec"
      t.pattern = "spec/helpers/notifications_helper_spec.rb"
    end

    Rake::TestTask.new(users: "db:test:prepare") do |t|
      t.libs << "spec"
      t.pattern = "spec/helpers/users_helper_spec.rb"
    end

	Rake::TestTask.new(shared: "db:test:prepare") do |t|
      t.libs << "spec"
      t.pattern = "spec/helpers/shared_helper_spec.rb"
    end
  end

  Rake::TestTask.new(lib: "db:test:prepare") do |t|
    t.libs << "spec"
    t.pattern = "spec/snell_mail/**/*.rb"
  end

  namespace :lib do
    Rake::TestTask.new(parser: "db:test:prepare") do |t|
      t.libs << "spec"
      t.pattern = "spec/snell_mail/notification_confirmation_parser_spec.rb"
    end
  end

  Rake::TestTask.new(integration: "db:test:prepare") do |t|
    t.libs << "spec"
    t.pattern = "spec/integration/**/*.rb"
  end

  namespace :integration do
    Rake::TestTask.new(sign_in_and_out: "db:test:prepare") do |t|
      t.libs << "spec"
      t.pattern = "spec/integration/sign_in_and_out_spec.rb"
    end

    Rake::TestTask.new(non_admin_user: "db:test:prepare") do |t|
      t.libs << "spec"
      t.pattern = "spec/integration/non_admin_user_spec.rb"
    end

    Rake::TestTask.new(admin_user: "db:test:prepare") do |t|
      t.libs << "spec"
      t.pattern = "spec/integration/admin_user/**/*.rb"
    end

    Rake::TestTask.new(all_users: "db:test:prepare") do |t|
      t.libs << "spec"
      t.pattern = "spec/integration/all_users_spec.rb"
    end

    namespace :admin_user do
      Rake::TestTask.new(cohabitant_management: "db:test:prepare") do |t|
        t.libs << "spec"
        t.pattern = "spec/integration/admin_user/cohabitant_management_spec.rb"
      end

      Rake::TestTask.new(user_management: "db:test:prepare") do |t|
        t.libs << "spec"
        t.pattern = "spec/integration/admin_user/user_management_spec.rb"
      end
    end
  end
end

task default: 'test:all'
