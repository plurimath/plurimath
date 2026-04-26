# Fix Unitsml ENOENT - missing unitsdb data files

## Problem
~44 test failures with `Errno::ENOENT` - unitsml gem can't find
`unitsdb/units.yaml`. The GitHub-hosted unitsml gem has an empty
`unitsdb/` directory (git submodule not initialized during `bundle install`).

## Affected specs (51 total failures)
- spec/plurimath/asciimath_spec.rb (23 failures)
- spec/plurimath/integration/asciimath_spec.rb (13 failures)
- spec/plurimath/math/formula/unitsml_spec.rb (3 failures)
- spec/plurimath/asciimath/metanorma/mn_samples_bipm_spec.rb (2 failures)
- spec/plurimath/asciimath/metanorma/mn_samples_jcgm_spec.rb (1 failure)
- spec/plurimath/asciimath/parser_spec.rb (1 failure)
- spec/plurimath/unicode_math_spec.rb (1 failure)

## Root cause
The unitsml gem's `unitsdb/` is a git submodule. When bundler installs
from GitHub, submodules aren't initialized. The local copy at
`../../unitsml/unitsml-ruby/` has the data.

## Fix
Change Gemfile to use local path for unitsml:
```ruby
gem "unitsml", path: "../../unitsml/unitsml-ruby"
```

## Status: Fixed (changed Gemfile to local path)
