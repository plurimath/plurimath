module Plurimath
  module Math
    module Symbols
      class Rightarrowbar < Symbol
        INPUT = {
          unicodemath: [["&#x21e5;"], parsing_wrapper(["RightArrowBar", "rightarrowbar"], lang: :unicode)],
          asciimath: [["&#x21e5;"], parsing_wrapper(["RightArrowBar", "rightarrowbar"], lang: :asciimath)],
          mathml: ["&#x21e5;"],
          latex: [["RightArrowBar", "rightarrowbar", "&#x21e5;"]],
          omml: ["&#x21e5;"],
          html: ["&#x21e5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\RightArrowBar"
        end

        def to_asciimath(**)
          parsing_wrapper("rightarrowbar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21e5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21e5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21e5;"
        end

        def to_html(**)
          "&#x21e5;"
        end
      end
    end
  end
end
