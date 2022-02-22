# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Sum
        attr_accessor :base, :exponent, :content

        def initialize(base = nil, exponent = nil, content = nil)
          @base = base
          @exponent = exponent
          @content = content
        end
        alias :value :base
      end
    end
  end
end
