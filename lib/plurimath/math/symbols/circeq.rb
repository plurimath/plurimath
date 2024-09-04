module Plurimath
  module Math
    module Symbols
      class Circeq < Symbol
        INPUT = {
          unicodemath: [["circeq", "&#x2257;"]],
          asciimath: [["&#x2257;"], parsing_wrapper(["circeq"], lang: :asciimath)],
          mathml: ["&#x2257;"],
          latex: [["circeq", "&#x2257;"]],
          omml: ["&#x2257;"],
          html: ["&#x2257;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circeq"
        end

        def to_asciimath(**)
          parsing_wrapper("circeq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2257;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2257;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2257;"
        end

        def to_html(**)
          "&#x2257;"
        end
      end
    end
  end
end
