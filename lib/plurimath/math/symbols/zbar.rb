module Plurimath
  module Math
    module Symbols
      class Zbar < Symbol
        INPUT = {
          unicodemath: [["&#x1b5;"], parsing_wrapper(["Zbar"], lang: :unicode)],
          asciimath: [["&#x1b5;"], parsing_wrapper(["Zbar"], lang: :asciimath)],
          mathml: ["&#x1b5;"],
          latex: [["Zbar", "&#x1b5;"]],
          omml: ["&#x1b5;"],
          html: ["&#x1b5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Zbar"
        end

        def to_asciimath(**)
          parsing_wrapper("Zbar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x1b5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x1b5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x1b5;"
        end

        def to_html(**)
          "&#x1b5;"
        end
      end
    end
  end
end
