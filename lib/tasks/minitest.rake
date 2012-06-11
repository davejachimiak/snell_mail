require "rake/testtask"

Rake::TestTask.new(:test => "db:test:prepare") do |t|
  t.libs << "spec"
  t.pattern = "spec/**/*_spec*.rb"
end

Rake::TestTask.new(:test_user_model => "db:test:prepare") do |t|
  t.libs << "spec"
  t.pattern = "spec/models/user_spec.rb"
end

task :default => :test