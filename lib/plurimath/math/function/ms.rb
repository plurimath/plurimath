# frozen_string_literal: true


module Plurimath
  module Math
    module Function
      class Ms < UnaryFunction
        def to_mathml_without_math_tag(intent, **)
          Utility.ox_element("ms") << parameter_one
        end

        def to_asciimath(**)
          "\"“#{parameter_one}”\""
        end

        def to_latex(**)
          "\\text{“#{parameter_one}”}"
        end

        def to_omml_without_math_tag(display_style, **)
          [
            (Utility.ox_element("t", namespace: "m") << "“#{parameter_one}”"),
          ]
        end

        def to_unicodemath(options:)
          Text.new(parameter_one).to_unicodemath(options: options)
        end

        def value
          parameter_one
        end

        def value=(content)
          @parameter_one = content.is_a?(Array) ? content.join(" ") : content
        end
      end
    end
  end
end
