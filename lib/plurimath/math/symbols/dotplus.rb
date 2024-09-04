module Plurimath
  module Math
    module Symbols
      class Dotplus < Symbol
        INPUT = {
          unicodemath: [["dotplus", "&#x2214;"]],
          asciimath: [["&#x2214;"], parsing_wrapper(["dotplus"], lang: :asciimath)],
          mathml: ["&#x2214;"],
          latex: [["dotplus", "&#x2214;"]],
          omml: ["&#x2214;"],
          html: ["&#x2214;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\dotplus"
        end

        def to_asciimath(**)
          parsing_wrapper("dotplus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2214;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2214;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2214;"
        end

        def to_html(**)
          "&#x2214;"
        end
      end
    end
  end
end
