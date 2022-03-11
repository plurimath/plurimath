# frozen_string_literal: true

module Plurimath
  module Math
    module Function
      class Log
        attr_accessor :base, :exponent, :content

        def initialize(base, exponent, content)
          @base = base
          @exponent = exponent
          @content = content
        end
      end
    end
  end
end
