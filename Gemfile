source "https://rubygems.org"

# Specify your gem's dependencies in plurimath.gemspec
gemspec

gem "canon"
# gem "lutaml-model", github: "lutaml/lutaml-model", branch: "main"
gem "oga"
# Override the runtime dependency locally; bootstrap GHA until amath is released.
if ENV["AMATH_PATH"]
  gem "amath", path: ENV["AMATH_PATH"]
elsif ENV["GITHUB_ACTIONS"] == "true"
  gem "amath", github: "plurimath/amath", ref: "b67f924477ce129e85926eda5973d771c007dfec"
end
# gem "omml", github: "plurimath/omml", branch: "main"
gem "opal-rspec", "~> 1.1.0a"
gem "ox"
# Parsanol::Slice for the amath SliceAdapter specs.
# 1.3.112 restores the v1 edition default (1.3.110 and 1.3.111 are yanked).
gem "parsanol", "~> 1.3", ">= 1.3.112"
gem "rake", "~> 12.0"
gem "rspec", "~> 3.0"
gem "rubocop-performance"
gem "rubocop-rake"
gem "rubocop-rspec"
gem "simplecov", require: false, group: :test
gem "irb", group: :development
