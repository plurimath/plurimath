module Plurimath
  module Math
    module Symbols
      class Sum < Symbol
        INPUT = {
          unicodemath: [["&#x2211;"]],
          asciimath: [["&#x2211;"]],
          mathml: ["&#x2211;"],
          latex: [["&#x2211;"]],
          omml: ["&#x2211;"],
          html: ["&#x2211;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sum"
        end

        def to_asciimath(**)
          "sum"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2211;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x2211;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2211;"
        end

        def to_html(**)
          "&#x2211;"
        end

        def tag_name
          "underover"
        end

        def omml_tag_name
          "undOvr"
        end
      end
    end
  end
end
