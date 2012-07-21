require "rake/testtask"

Rake::TestTask.new(test: "db:test:prepare") do |t|
  t.libs << "spec"
  t.pattern = "spec/**/*_spec*.rb"
end

Rake::TestTask.new(integration: "db:test:prepare") do |t|
  t.libs << "spec"
  t.pattern = "spec/integration/integration_spec.rb"
end

Rake::TestTask.new(user_spec: "db:test:prepare") do |t|
  t.libs << "spec"
  t.pattern = "spec/models/user_spec.rb"
end

Rake::TestTask.new(cohabitant_spec: "db:test:prepare") do |t|
  t.libs << "spec"
  t.pattern = "spec/models/cohabitant_spec.rb"
end

Rake::TestTask.new(notification_spec: "db:test:prepare") do |t|
  t.libs << "spec"
  t.pattern = "spec/models/notification_spec.rb"
end

Rake::TestTask.new(notification_confirmation_parser_spec: "db:test:prepare") do |t|
  t.libs << "spec"
  t.pattern = "spec/lib/snell_mail/notification_confirmation_parser_spec.rb"
end
task default: :test
