module Plurimath
  module Math
    module Symbols
      class Iff < Symbol
        INPUT = {
          unicodemath: [["iff", "&#x27ff;"], parsing_wrapper(["longrightsquigarrow"])],
          asciimath: [["&#x27ff;"], parsing_wrapper(["iff", "longrightsquigarrow"])],
          mathml: ["&#x27ff;"],
          latex: [["longrightsquigarrow", "&#x27ff;"], parsing_wrapper(["iff"])],
          omml: ["&#x27ff;"],
          html: ["&#x27ff;"],
        }.freeze

        # output methods
        def to_latex
          "\\iff"
        end

        def to_asciimath
          "iff"
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x27ff;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x27ff;"
        end

        def to_omml_without_math_tag(_)
          "&#x27ff;"
        end

        def to_html
          "&#x27ff;"
        end
      end
    end
  end
end
