module Plurimath
  module Math
    module Symbols
      class Rightdowncurvedarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2937;"], parsing_wrapper(["rightdowncurvedarrow"], lang: :unicode)],
          asciimath: [["&#x2937;"], parsing_wrapper(["rightdowncurvedarrow"], lang: :asciimath)],
          mathml: ["&#x2937;"],
          latex: [["rightdowncurvedarrow", "&#x2937;"]],
          omml: ["&#x2937;"],
          html: ["&#x2937;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightdowncurvedarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("rightdowncurvedarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2937;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2937;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2937;"
        end

        def to_html(**)
          "&#x2937;"
        end
      end
    end
  end
end
