module Plurimath
  module Math
    module Symbols
      class Angleubar < Symbol
        INPUT = {
          unicodemath: [["&#x29a4;"], parsing_wrapper(["angleubar"], lang: :unicode)],
          asciimath: [["&#x29a4;"], parsing_wrapper(["angleubar"], lang: :asciimath)],
          mathml: ["&#x29a4;"],
          latex: [["angleubar", "&#x29a4;"]],
          omml: ["&#x29a4;"],
          html: ["&#x29a4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\angleubar"
        end

        def to_asciimath(**)
          parsing_wrapper("angleubar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29a4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29a4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29a4;"
        end

        def to_html(**)
          "&#x29a4;"
        end
      end
    end
  end
end
