module Plurimath
  module Math
    module Symbols
      class Dint < Symbol
        INPUT = {
          unicodemath: [["&#x22c2;", "bigcap"], parsing_wrapper(["nnn", "dint"])],
          asciimath: [["bigcap", "nnn", "&#x22c2;"], parsing_wrapper(["dint"])],
          mathml: ["&#x22c2;"],
          latex: [["bigcap", "dint", "&#x22c2;"], parsing_wrapper(["nnn"])],
          omml: ["&#x22c2;"],
          html: ["&#x22c2;"],
        }.freeze

        # output methods
        def to_latex
          "\\bigcap"
        end

        def to_asciimath
          parsing_wrapper("dint")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x22c2;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mi") << "&#x22c2;"
        end

        def to_omml_without_math_tag(_)
          "&#x22c2;"
        end

        def to_html
          "&#x22c2;"
        end

        def is_nary_symbol?
          true
        end

        def nary_intent_name
          "n-ary"
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
