module Plurimath
  module Math
    module Symbols
      class Wideparen < Symbol
        INPUT = {
          unicodemath: [["&#x23dc;"], parsing_wrapper(["overparen", "wideparen"], lang: :unicode)],
          asciimath: [["&#x23dc;"], parsing_wrapper(["overparen", "wideparen"], lang: :asciimath)],
          mathml: ["&#x23dc;"],
          latex: [["overparen", "wideparen", "&#x23dc;"]],
          omml: ["&#x23dc;"],
          html: ["&#x23dc;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\overparen"
        end

        def to_asciimath(**)
          parsing_wrapper("wideparen", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23dc;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23dc;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23dc;"
        end

        def to_html(**)
          "&#x23dc;"
        end
      end
    end
  end
end
