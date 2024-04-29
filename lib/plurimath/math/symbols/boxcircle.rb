module Plurimath
  module Math
    module Symbols
      class Boxcircle < Symbol
        INPUT = {
          unicodemath: [["&#x29c7;"], parsing_wrapper(["boxcircle"])],
          asciimath: [["&#x29c7;"], parsing_wrapper(["boxcircle"])],
          mathml: ["&#x29c7;"],
          latex: [["boxcircle", "&#x29c7;"]],
          omml: ["&#x29c7;"],
          html: ["&#x29c7;"],
        }.freeze

        # output methods
        def to_latex
          "\\boxcircle"
        end

        def to_asciimath
          parsing_wrapper("boxcircle")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x29c7;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x29c7;"
        end

        def to_omml_without_math_tag(_)
          "&#x29c7;"
        end

        def to_html
          "&#x29c7;"
        end
      end
    end
  end
end
