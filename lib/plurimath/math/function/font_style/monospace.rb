# frozen_string_literal: true

require_relative "../font_style"

module Plurimath
  module Math
    module Function
      class FontStyle
        class Monospace < FontStyle
          def initialize(parameter_one,
                         parameter_two = "monospace")
            super
          end

          def to_asciimath
            "mathtt#{wrapped(parameter_one)}"
          end
        end
      end
    end
  end
end
