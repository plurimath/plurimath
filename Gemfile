source "https://rubygems.org"

# Specify your gem's dependencies in plurimath.gemspec
gemspec

gem "canon"
# gem "lutaml-model", github: "lutaml/lutaml-model", branch: "main"
gem "oga"
# AMATH_PATH points at a local amath checkout instead of the released gem.
gem "amath", path: ENV["AMATH_PATH"] if ENV["AMATH_PATH"]
# gem "omml", github: "plurimath/omml", branch: "main"
gem "opal-rspec", "~> 1.1.0a"
gem "ox"
# Parsanol::Slice for the amath SliceAdapter specs.
gem "parsanol", ">= 1.3.107"
gem "rake", "~> 12.0"
gem "rspec", "~> 3.0"
gem "rubocop-performance"
gem "rubocop-rake"
gem "rubocop-rspec"
gem "simplecov", require: false, group: :test
gem "irb", group: :development
