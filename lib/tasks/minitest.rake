require "rake/testtask"

Rake::TestTask.new(:test => "db:test:prepare") do |t|
  t.libs << "spec"
  t.pattern = "spec/**/*_spec*.rb"
end

Rake::TestTask.new(:integration => "db:test:prepare") do |t|
  t.libs << "spec"
  t.pattern = "spec/integration/integration_spec.rb"
end

Rake::TestTask.new(:test_user_model => "db:test:prepare") do |t|
  t.libs << "spec"
  t.pattern = "spec/models/user_spec.rb"
end

Rake::TestTask.new(:test_cohabitant_model => "db:test:prepare") do |t|
  t.libs << "spec"
  t.pattern = "spec/models/cohabitant_spec.rb"
end

Rake::TestTask.new(:test_notification_model => "db:test:prepare") do |t|
  t.libs << "spec"
  t.pattern = "spec/models/notification_spec.rb"
end

task :default => :test