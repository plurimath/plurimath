module Plurimath
  module Math
    module Symbols
      class Supsetneqq < Symbol
        INPUT = {
          unicodemath: [["&#x2acc;"], parsing_wrapper(["supsetneqq"], lang: :unicode)],
          asciimath: [["&#x2acc;"], parsing_wrapper(["supsetneqq"], lang: :asciimath)],
          mathml: ["&#x2acc;"],
          latex: [["supsetneqq", "&#x2acc;"]],
          omml: ["&#x2acc;"],
          html: ["&#x2acc;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\supsetneqq"
        end

        def to_asciimath(**)
          parsing_wrapper("supsetneqq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2acc;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2acc;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2acc;"
        end

        def to_html(**)
          "&#x2acc;"
        end
      end
    end
  end
end
