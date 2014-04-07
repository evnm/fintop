require 'bundler/gem_tasks'
require 'rake/clean'
require 'rake/testtask'

CLEAN.include('pkg')

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end
