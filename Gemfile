source "https://rubygems.org"

# Specify your gem's dependencies in plurimath.gemspec
gemspec

gem "canon"
# gem "lutaml-model", github: "lutaml/lutaml-model", branch: "main"
gem "oga"
# AsciiMath parser; pin the companion flat-chain fix until it is merged.
# AMATH_PATH points at a local amath checkout instead.
if ENV["AMATH_PATH"]
  gem "amath", path: ENV["AMATH_PATH"]
else
  gem "amath", github: "plurimath/amath", ref: "262c6ee2590c571185c25ec56ed370578495f486"
end
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
