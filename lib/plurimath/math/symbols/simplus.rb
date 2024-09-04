module Plurimath
  module Math
    module Symbols
      class Simplus < Symbol
        INPUT = {
          unicodemath: [["&#x2a24;"], parsing_wrapper(["simplus"], lang: :unicode)],
          asciimath: [["&#x2a24;"], parsing_wrapper(["simplus"], lang: :asciimath)],
          mathml: ["&#x2a24;"],
          latex: [["simplus", "&#x2a24;"]],
          omml: ["&#x2a24;"],
          html: ["&#x2a24;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\simplus"
        end

        def to_asciimath(**)
          parsing_wrapper("simplus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a24;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a24;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a24;"
        end

        def to_html(**)
          "&#x2a24;"
        end
      end
    end
  end
end
