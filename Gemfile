source "https://rubygems.org"

# Specify your gem's dependencies in plurimath.gemspec
gemspec

gem "canon"
# Optional native image-rendering backend for `Formula#render` / `plurimath
# render`. Git-pinned until `lasem` ships to RubyGems; intentionally NOT a
# gemspec runtime dependency so Opal/plurimath-js and lasem-less installs keep
# working. For local dev against an in-progress checkout:
#   bundle config set --local local.lasem /path/to/lasem-ruby
gem "lasem", github: "plurimath/lasem-ruby", branch: "main", submodules: true
# gem "lutaml-model", github: "lutaml/lutaml-model", branch: "main"
gem "oga"
# spec_helper selects the Nokogiri adapter directly.
gem "nokogiri"
# AsciiMath parser; tracks amath main until a release is published.
# AMATH_PATH points at a local amath checkout instead.
if ENV["AMATH_PATH"]
  gem "amath", path: ENV["AMATH_PATH"]
else
  gem "amath", github: "plurimath/amath", ref: "b67f924477ce129e85926eda5973d771c007dfec"
end
# gem "omml", github: "plurimath/omml", branch: "main"
gem "opal-rspec", "~> 1.1.0a"
gem "ox"
gem "parsanol"
gem "rake", "~> 12.0"
gem "rspec", "~> 3.0"
gem "rubocop-performance"
gem "rubocop-rake"
gem "rubocop-rspec"
gem "simplecov", require: false, group: :test
gem "irb", group: :development
