# frozen_string_literal: true

require_relative "../table"

module Plurimath
  module Math
    module Function
      class Table
        class Split < Table
          def initialize(value,
                         open_paren = "[",
                         close_paren = "]",
                         options = {})
            super
          end

          def to_latex(options:)
            "\\begin#{opening}#{latex_content(options: options)}\\end#{matrix_class}"
          end
        end
      end
    end
  end
end
