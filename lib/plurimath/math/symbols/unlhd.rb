module Plurimath
  module Math
    module Symbols
      class Unlhd < Symbol
        INPUT = {
          unicodemath: [["trianglelefteq", "&#x22b4;"], parsing_wrapper(["unlhd"], lang: :unicode)],
          asciimath: [["&#x22b4;"], parsing_wrapper(["trianglelefteq", "unlhd"], lang: :asciimath)],
          mathml: ["&#x22b4;"],
          latex: [["trianglelefteq", "unlhd", "&#x22b4;"]],
          omml: ["&#x22b4;"],
          html: ["&#x22b4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\trianglelefteq"
        end

        def to_asciimath(**)
          parsing_wrapper("unlhd", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22b4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22b4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22b4;"
        end

        def to_html(**)
          "&#x22b4;"
        end
      end
    end
  end
end
