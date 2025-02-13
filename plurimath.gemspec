require_relative 'lib/plurimath/version'

Gem::Specification.new do |spec|
  spec.name          = "plurimath"
  spec.version       = Plurimath::VERSION
  spec.authors       = ['Ribose Inc.']
  spec.email         = ['open.source@ribose.com']

  spec.summary       = 'Converts LaTeX math into MathML.'
  spec.description   = 'Converts LaTeX math into MathML.'
  spec.homepage      = 'https://github.com/plurimath/plurimath'
  spec.license       = 'BSD-2-Clause'

  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/plurimath/plurimath'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'ox'
  spec.add_dependency 'mml'
  spec.add_dependency 'thor'
  spec.add_dependency 'parslet'
  spec.add_dependency 'unitsml'
  spec.add_dependency 'bigdecimal'
  spec.add_dependency 'lutaml-model'
end
