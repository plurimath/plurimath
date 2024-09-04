module Plurimath
  module Math
    module Symbols
      class Rightupteevector < Symbol
        INPUT = {
          unicodemath: [["&#x295c;"], parsing_wrapper(["upharpoonrightbar", "RightUpTeeVector"], lang: :unicode)],
          asciimath: [["&#x295c;"], parsing_wrapper(["upharpoonrightbar", "RightUpTeeVector"], lang: :asciimath)],
          mathml: ["&#x295c;"],
          latex: [["upharpoonrightbar", "RightUpTeeVector", "&#x295c;"]],
          omml: ["&#x295c;"],
          html: ["&#x295c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upharpoonrightbar"
        end

        def to_asciimath(**)
          parsing_wrapper("RightUpTeeVector", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x295c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x295c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x295c;"
        end

        def to_html(**)
          "&#x295c;"
        end
      end
    end
  end
end
