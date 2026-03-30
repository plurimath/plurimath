module Plurimath
  module Math
    module Symbols
      class Zz < Symbol
        INPUT = {
          unicodemath: [["&#x2124;"], parsing_wrapper(["ZZ"], lang: :unicode)],
          asciimath: ["&#x2124;", "ZZ"],
          mathml: ["&#x2124;"],
          latex: ["ZZ", "&#x2124;"],
          omml: ["&#x2124;"],
          html: ["&#x2124;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ZZ"
        end

        def to_asciimath(**)
          "ZZ"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2124;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2124;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2124;"
        end

        def to_html(**)
          "&#x2124;"
        end
      end
    end
  end
end
