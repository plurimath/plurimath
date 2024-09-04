module Plurimath
  module Math
    module Symbols
      class Cdots < Symbol
        INPUT = {
          unicodemath: [["&#x22ef;"], parsing_wrapper(["cdots", "unicodecdots"], lang: :unicode)],
          asciimath: [["cdots", "&#x22ef;"], parsing_wrapper(["unicodecdots"], lang: :asciimath)],
          mathml: ["&#x22ef;"],
          latex: [["unicodecdots", "cdots", "&#x22ef;"]],
          omml: ["&#x22ef;"],
          html: ["&#x22ef;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\cdots"
        end

        def to_asciimath(**)
          "cdots"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22ef;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x22ef;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22ef;"
        end

        def to_html(**)
          "&#x22ef;"
        end
      end
    end
  end
end
