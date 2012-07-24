require "rake/testtask"

namespace :test do
  Rake::TestTask.new(all: ['integration', 'lib', 'models']) do |t|
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

  Rake::TestTask.new(helpers: "db:test:prepare") do |t|
    t.libs << "spec"
    t.pattern = "spec/helpers/**/*.rb"
  end

  namespace :helpers do
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
    t.pattern = "spec/integration/integration_spec.rb"
  end
end

task default: 'test:all'
