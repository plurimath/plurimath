# frozen_string_literal: true

require_relative "../font_style"

module Plurimath
  module Math
    module Function
      class FontStyle
        class DoubleStruck < FontStyle
          def initialize(parameter_one,
                         parameter_two = "double-struck")
            super
          end

          def to_asciimath
            "mathbb#{wrapped(parameter_one)}"
          end
        end
      end
    end
  end
end
