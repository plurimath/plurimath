module Plurimath
  module Math
    module Symbols
      class Leq < Symbol
        INPUT = {
          unicodemath: [["le", "leq", "&#x2264;"], parsing_wrapper(["<="], lang: :unicode)],
          asciimath: [["<=", "le", "&#x2264;"], parsing_wrapper(["leq"], lang: :asciimath)],
          mathml: ["&#x2264;"],
          latex: [["leq", "le", "&#x2264;"], parsing_wrapper(["<="], lang: :latex)],
          omml: ["&#x2264;"],
          html: ["&#x2264;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\le"
        end

        def to_asciimath(**)
          "<="
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2264;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2264;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2264;"
        end

        def to_html(**)
          "&#x2264;"
        end
      end
    end
  end
end
