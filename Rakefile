require "erb"
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'opal/rspec/rake_task'

RSpec::Core::RakeTask.new(:spec)

# Opal testing support
begin
  Opal::RSpec::RakeTask.new(:"spec-opal")
rescue LoadError
  # Likely the dependencies haven't been upstreamed yet. Ensure you
  # run those tests via the `plurimath-js` repo's `env/plurimath`
  # script.
end

task :default => :spec
