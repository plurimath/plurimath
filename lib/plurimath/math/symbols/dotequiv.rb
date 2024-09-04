module Plurimath
  module Math
    module Symbols
      class Dotequiv < Symbol
        INPUT = {
          unicodemath: [["&#x2a67;"], parsing_wrapper(["dotequiv"], lang: :unicode)],
          asciimath: [["&#x2a67;"], parsing_wrapper(["dotequiv"], lang: :asciimath)],
          mathml: ["&#x2a67;"],
          latex: [["dotequiv", "&#x2a67;"]],
          omml: ["&#x2a67;"],
          html: ["&#x2a67;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\dotequiv"
        end

        def to_asciimath(**)
          parsing_wrapper("dotequiv", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a67;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a67;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a67;"
        end

        def to_html(**)
          "&#x2a67;"
        end
      end
    end
  end
end
