# frozen_string_literal: true

require_relative "../font_style"

module Plurimath
  module Math
    module Function
      class FontStyle
        class Fraktur < FontStyle
          def initialize(parameter_one,
                         parameter_two = "fraktur")
            super
          end

          def to_asciimath
            "fr#{wrapped(parameter_one)}"
          end
        end
      end
    end
  end
end
