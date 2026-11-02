# frozen_string_literal: true

module Plurimath
  class UnicodeMath
    module ParsingRules
      module Helper
        def self.included(base)
          base.extend(Parsanol::ClassMethods)
        end
      end
    end
  end
end
