module Plurimath
  module Math
    module Symbols
      class Prod < Symbol
        INPUT = {
          unicodemath: [["&#x220f;"]],
          asciimath: [["&#x220f;"]],
          mathml: ["&#x220f;"],
          latex: [["&#x220f;"]],
          omml: ["&#x220f;"],
          html: ["&#x220f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\prod"
        end

        def to_asciimath(**)
          "prod"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x220f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x220f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x220f;"
        end

        def to_html(**)
          "&#x220f;"
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
