module Plurimath
  module Math
    module Symbols
      class In < Symbol
        INPUT = {
          unicodemath: [["in", "&#x2208;"]],
          asciimath: [["in", "&#x2208;"]],
          mathml: ["&#x2208;"],
          latex: [["in", "&#x2208;"]],
          omml: ["&#x2208;"],
          html: ["&#x2208;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\in"
        end

        def to_asciimath(**)
          "in"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2208;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x2208;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2208;"
        end

        def to_html(**)
          "&#x2208;"
        end
      end
    end
  end
end
