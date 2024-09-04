module Plurimath
  module Math
    module Symbols
      class Bigtalloblong < Symbol
        INPUT = {
          unicodemath: [["&#x2aff;"], parsing_wrapper(["bigtalloblong"], lang: :unicode)],
          asciimath: [["&#x2aff;"], parsing_wrapper(["bigtalloblong"], lang: :asciimath)],
          mathml: ["&#x2aff;"],
          latex: [["bigtalloblong", "&#x2aff;"]],
          omml: ["&#x2aff;"],
          html: ["&#x2aff;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigtalloblong"
        end

        def to_asciimath(**)
          parsing_wrapper("bigtalloblong", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2aff;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2aff;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2aff;"
        end

        def to_html(**)
          "&#x2aff;"
        end
      end
    end
  end
end
