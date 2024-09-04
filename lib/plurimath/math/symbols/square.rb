module Plurimath
  module Math
    module Symbols
      class Square < Symbol
        INPUT = {
          unicodemath: [["&#x2610;"], parsing_wrapper(["Square"], lang: :unicode)],
          asciimath: [["&#x2610;"], parsing_wrapper(["Square"], lang: :asciimath)],
          mathml: ["&#x2610;"],
          latex: [["Square", "&#x2610;"]],
          omml: ["&#x2610;"],
          html: ["&#x2610;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Square"
        end

        def to_asciimath(**)
          parsing_wrapper("Square", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2610;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2610;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2610;"
        end

        def to_html(**)
          "&#x2610;"
        end
      end
    end
  end
end
