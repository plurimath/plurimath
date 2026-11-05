source "https://rubygems.org"

# Specify your gem's dependencies in plurimath.gemspec
gemspec

gem "canon"
gem "leptris" # third XML engine under test (spec_helper runs each example per engine)
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
# gem "omml", github: "plurimath/omml", branch: "main"
gem "opal-rspec", "~> 1.1.0a"
gem "ox"
gem "parsanol"
# umath is unpublished; pinned until its first release.
gem "umath", github: "plurimath/umath", ref: "3fa31a16c9df4b375f3af7ccc4c103c0f46bd57f"
gem "rake", "~> 12.0"
gem "rspec", "~> 3.0"
gem "rubocop-performance"
gem "rubocop-rake"
gem "rubocop-rspec"
gem "simplecov", require: false, group: :test
gem "irb", group: :development
