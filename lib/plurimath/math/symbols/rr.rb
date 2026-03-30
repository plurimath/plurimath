module Plurimath
  module Math
    module Symbols
      class Rr < Symbol
        INPUT = {
          unicodemath: [["&#x211d;"], parsing_wrapper(["RR"], lang: :unicode)],
          asciimath: [["&#x211d;"], parsing_wrapper(["RR"], lang: :asciimath)],
          mathml: ["&#x211d;"],
          latex: [["RR", "&#x211d;"]],
          omml: ["&#x211d;"],
          html: ["&#x211d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\RR"
        end

        def to_asciimath(**)
          parsing_wrapper("RR", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x211d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x211d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x211d;"
        end

        def to_html(**)
          "&#x211d;"
        end
      end
    end
  end
end
