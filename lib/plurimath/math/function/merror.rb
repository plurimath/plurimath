# frozen_string_literal: true

require_relative "unary_function"
require_relative "../../mathml/utility"

module Plurimath
  module Math
    module Function
      class Merror < UnaryFunction
        include Mathml::Utility

        def to_asciimath(**); end

        def to_latex(**); end

        def to_mathml_without_math_tag(intent, options:)
          merror = Utility.ox_element("merror")
          Utility.update_nodes(merror, mathml_value(intent, options: options))
        end

        def to_omml_without_math_tag(_, **); end

        def to_unicodemath(**); end
      end
    end
  end
end
