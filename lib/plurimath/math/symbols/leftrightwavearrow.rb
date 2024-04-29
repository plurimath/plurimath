module Plurimath
  module Math
    module Symbols
      class Leftrightwavearrow < Symbol
        INPUT = {
          unicodemath: [["leftrightwavearrow", "&#x21ad;"], parsing_wrapper(["leftrightsquigarrow"])],
          asciimath: [["&#x21ad;"], parsing_wrapper(["leftrightwavearrow", "leftrightsquigarrow"])],
          mathml: ["&#x21ad;"],
          latex: [["leftrightsquigarrow", "&#x21ad;"], parsing_wrapper(["leftrightwavearrow"])],
          omml: ["&#x21ad;"],
          html: ["&#x21ad;"],
        }.freeze

        # output methods
        def to_latex
          "\\leftrightsquigarrow"
        end

        def to_asciimath
          parsing_wrapper("leftrightwavearrow")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x21ad;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x21ad;"
        end

        def to_omml_without_math_tag(_)
          "&#x21ad;"
        end

        def to_html
          "&#x21ad;"
        end
      end
    end
  end
end
