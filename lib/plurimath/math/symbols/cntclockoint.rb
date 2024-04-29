module Plurimath
  module Math
    module Symbols
      class Cntclockoint < Symbol
        INPUT = {
          unicodemath: [["&#x2233;"], parsing_wrapper(["ointctrclockwise", "cntclockoint"])],
          asciimath: [["&#x2233;"], parsing_wrapper(["ointctrclockwise", "cntclockoint"])],
          mathml: ["&#x2233;"],
          latex: [["ointctrclockwise", "cntclockoint", "&#x2233;"]],
          omml: ["&#x2233;"],
          html: ["&#x2233;"],
        }.freeze

        # output methods
        def to_latex
          "\\ointctrclockwise"
        end

        def to_asciimath
          parsing_wrapper("cntclockoint")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2233;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2233;"
        end

        def to_omml_without_math_tag(_)
          "&#x2233;"
        end

        def to_html
          "&#x2233;"
        end

        def is_nary_symbol?
          true
        end
      end
    end
  end
end
