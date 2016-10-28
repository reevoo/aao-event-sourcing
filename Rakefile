begin
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new(:rspec)

  task default: %w(rspec)
rescue LoadError
  puts "RSpec not loaded"
end
