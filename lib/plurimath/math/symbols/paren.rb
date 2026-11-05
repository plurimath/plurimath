module Plurimath
  module Math
    module Symbols
      class Paren < Symbol
        INPUT = {}.freeze

        def paren?
          true
        end

        # The paren classes load on first reference, like the other symbols.
        if RUBY_ENGINE != "opal"
          SymbolIndex::PAREN_FILES.each do |name, file|
            autoload name.to_sym, File.join(__dir__, "#{file}.rb")
          end
        end
      end
    end
  end
end
