source "https://rubygems.org"

# Specify your gem's dependencies in plurimath.gemspec
gemspec

# The quoted uncertainty channel (amath#17) ships in amath 0.2.1, resolved
# from RubyGems; the gemspec floor (amath >= 0.2.2, < 0.3) admits it.
gem "canon"
gem "fiddle", "~> 1.1"
# Candidate adds boxed parsing; replace this development pin after latexmath#72 is released.
gem "latexmath", github: "plurimath/latexmath", ref: "b013c397b6dd68d953a43edb757efc43d4281d64"
gem "leptris" # third XML engine under test (spec_helper runs each example per engine)
# Optional native image-rendering backend for `Formula#render` / `plurimath
# render`. Git-pinned until `lasem` ships to RubyGems; intentionally NOT a
# gemspec runtime dependency so Opal/plurimath-js and lasem-less installs keep
# working. For local dev against an in-progress checkout:
#   bundle config set --local local.lasem /path/to/lasem-ruby
gem "lasem", github: "plurimath/lasem-ruby", branch: "main", submodules: true
# The logifos render engine (`Formula#render(engine: :logifos)`): MathML to
# SVG through the logifos native library the caller supplies with
# library_path: and fonts:. Git-pinned until `logifos` ships to RubyGems;
# intentionally NOT a gemspec runtime dependency so logifos-less installs
# keep working. For local dev against an in-progress checkout:
#   bundle config set --local local.logifos /path/to/logifos-ruby
gem "logifos", github: "logifos/logifos-ruby", ref: "5a79ddfc85462d1763963a63a827072be9fdb242"
# gem "lutaml-model", github: "lutaml/lutaml-model", branch: "main"
gem "oga"
# spec_helper selects the Nokogiri adapter directly.
gem "nokogiri"
# gem "omml", github: "plurimath/omml", branch: "main"
gem "opal-rspec", "~> 1.1.0a"
gem "ox"
gem "parsanol"
gem "umath", "~> 0.1"
# Qualify the serialized quantity profile against the exact conversion producer.
# Remove this development pin when the exact fractional conversion ships.
gem "unitsml", github: "unitsml/unitsml-ruby", ref: "206b7732d3b457b54e22c13e6c7f19f1f721b0c1"
gem "rake", "~> 12.0"
gem "rspec", "~> 3.0"
gem "rubocop-performance"
gem "rubocop-rake"
gem "rubocop-rspec"
gem "simplecov", require: false, group: :test
gem "irb", group: :development
