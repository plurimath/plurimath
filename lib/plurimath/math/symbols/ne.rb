module Plurimath
  module Math
    module Symbols
      class Ne < Symbol
        INPUT = {
          unicodemath: [["neq", "ne", "&#x2260;"], parsing_wrapper(["!="], lang: :unicode)],
          asciimath: [["!=", "ne", "&#x2260;"], parsing_wrapper(["neq"], lang: :asciimath)],
          mathml: ["&#x2260;"],
          latex: [["neq", "ne", "&#x2260;"], parsing_wrapper(["!="], lang: :latex)],
          omml: ["&#x2260;"],
          html: ["&#x2260;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ne"
        end

        def to_asciimath(**)
          "ne"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2260;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x2260;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2260;"
        end

        def to_html(**)
          "&#x2260;"
        end
      end
    end
  end
end
