require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.test_files = FileList['test/*.rb'].exclude('test/test_helper.rb')
end

task :build => :test

task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['test'].execute
end
