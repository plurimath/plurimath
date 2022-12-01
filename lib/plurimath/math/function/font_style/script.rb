# frozen_string_literal: true

require_relative "../font_style"

module Plurimath
  module Math
    module Function
      class FontStyle
        class Script < FontStyle
          def initialize(parameter_one,
                         parameter_two = "script")
            super
          end

          def to_asciimath
            "mathcal#{wrapped(parameter_one)}"
          end
        end
      end
    end
  end
end
