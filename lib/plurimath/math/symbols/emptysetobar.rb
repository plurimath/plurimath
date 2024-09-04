module Plurimath
  module Math
    module Symbols
      class Emptysetobar < Symbol
        INPUT = {
          unicodemath: [["&#x29b1;"], parsing_wrapper(["emptysetobar"], lang: :unicode)],
          asciimath: [["&#x29b1;"], parsing_wrapper(["emptysetobar"], lang: :asciimath)],
          mathml: ["&#x29b1;"],
          latex: [["emptysetobar", "&#x29b1;"]],
          omml: ["&#x29b1;"],
          html: ["&#x29b1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\emptysetobar"
        end

        def to_asciimath(**)
          parsing_wrapper("emptysetobar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29b1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29b1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29b1;"
        end

        def to_html(**)
          "&#x29b1;"
        end
      end
    end
  end
end
