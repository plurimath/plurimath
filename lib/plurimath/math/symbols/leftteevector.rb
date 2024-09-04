module Plurimath
  module Math
    module Symbols
      class Leftteevector < Symbol
        INPUT = {
          unicodemath: [["&#x295a;"], parsing_wrapper(["leftharpoonupbar", "LeftTeeVector"], lang: :unicode)],
          asciimath: [["&#x295a;"], parsing_wrapper(["leftharpoonupbar", "LeftTeeVector"], lang: :asciimath)],
          mathml: ["&#x295a;"],
          latex: [["leftharpoonupbar", "LeftTeeVector", "&#x295a;"]],
          omml: ["&#x295a;"],
          html: ["&#x295a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftharpoonupbar"
        end

        def to_asciimath(**)
          parsing_wrapper("LeftTeeVector", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x295a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x295a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x295a;"
        end

        def to_html(**)
          "&#x295a;"
        end
      end
    end
  end
end
