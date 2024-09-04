module Plurimath
  module Math
    module Symbols
      class If < Symbol
        INPUT = {
          unicodemath: [["if"]],
          asciimath: [["if"]],
          mathml: ["if"],
          latex: [["if"]],
          omml: ["if"],
          html: ["if"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\operatorname{if}"
        end

        def to_asciimath(**)
          "if"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("if")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "if"
        end

        def to_omml_without_math_tag(_, **)
          "if"
        end

        def to_html(**)
          "if"
        end
      end
    end
  end
end
