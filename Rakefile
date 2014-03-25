#!/usr/bin/env rake

require 'rake/testtask'
Dir['./lib/tasks/**/*.rake'].each { |file| load file }

Rake::TestTask.new :test do |t|
  t.libs << 'test'
  t.pattern = './test/**/*_test.rb'
end

task default: :test
