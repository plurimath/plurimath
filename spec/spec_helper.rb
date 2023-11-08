if RUBY_ENGINE != "opal"
  require "simplecov"
  SimpleCov.start do
    add_filter "/spec/"
  end

  require "bundler/setup"
end
require "plurimath"
require "rspec/matchers"
if RUBY_ENGINE == "opal"
  require "oga"
else
  require "nokogiri"
end
require "equivalent-xml/rspec_matchers"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
