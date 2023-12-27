# frozen_string_literal: true

module Plurimath
  class UnicodeMath
    module ParsingRules
      module Helper
        def self.included(base)
          base.extend(ClassMethods)
        end
      end

      module ClassMethods
        def rule(name, &block)
          Parslet::Parser.rule(name, &block)
        end
      end
    end
  end
end
