module Plurimath
  module Math
    module Symbols
      class Backslash < Symbol
        INPUT = {
          unicodemath: [["&#x5c;"], parsing_wrapper(["backslash", "\\"], lang: :unicode)],
          asciimath: ["backslash", "&#x5c;", "\\"],
          mathml: ["&#x5c;"],
          latex: [["backslash", "&#x5c;"], parsing_wrapper(["\\"], lang: :latex)],
          omml: ["&#x5c;"],
          html: ["&#x5c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\backslash"
        end

        def to_asciimath(**)
          "\\"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x5c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "\\"
        end

        def to_omml_without_math_tag(_, **)
          "&#x5c;"
        end

        def to_html(**)
          "&#x5c;"
        end
      end
    end
  end
end
