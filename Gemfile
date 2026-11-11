source "https://rubygems.org"

# Specify your gem's dependencies in plurimath.gemspec
gemspec

# amath's typed model (Amath.parse_model returning Amath::Model::Document) ships in
# amath 0.2.0, which is not on RubyGems yet. Until it is, amath comes from this
# main commit (its version file still says 0.1.0). Drop this line once 0.2.0
# is published, and do not release plurimath before then.
gem "amath", git: "https://github.com/plurimath/amath",
             ref: "a4ed231057aeb98022f5c825807e888946a9e71c"
gem "canon"
# Candidate includes typed symbol portability; retain its exact pin until published.
gem "latexmath", github: "plurimath/latexmath", ref: "372e377261c82e801ce755ebca7abfae1336ec39"
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
gem "umath", "~> 0.1"
gem "rake", "~> 12.0"
gem "rspec", "~> 3.0"
gem "rubocop-performance"
gem "rubocop-rake"
gem "rubocop-rspec"
gem "simplecov", require: false, group: :test
gem "irb", group: :development
