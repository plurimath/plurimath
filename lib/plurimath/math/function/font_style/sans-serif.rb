# frozen_string_literal: true

require_relative "../font_style"

module Plurimath
  module Math
    module Function
      class FontStyle
        class SansSerif < FontStyle
          def initialize(parameter_one,
                         parameter_two = "sans-serif")
            super
          end

          def to_asciimath
            "mathsf#{wrapped(parameter_one)}"
          end
        end
      end
    end
  end
end
