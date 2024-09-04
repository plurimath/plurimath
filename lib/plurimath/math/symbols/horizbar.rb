module Plurimath
  module Math
    module Symbols
      class Horizbar < Symbol
        INPUT = {
          unicodemath: [["&#x2015;"], parsing_wrapper(["horizbar"], lang: :unicode)],
          asciimath: [["&#x2015;"], parsing_wrapper(["horizbar"], lang: :asciimath)],
          mathml: ["&#x2015;"],
          latex: [["horizbar", "&#x2015;"]],
          omml: ["&#x2015;"],
          html: ["&#x2015;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\horizbar"
        end

        def to_asciimath(**)
          parsing_wrapper("horizbar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2015;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2015;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2015;"
        end

        def to_html(**)
          "&#x2015;"
        end
      end
    end
  end
end
