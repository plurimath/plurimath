module Plurimath
  module Math
    module Symbols
      class Measangleldtosw < Symbol
        INPUT = {
          unicodemath: [["&#x29ab;"], parsing_wrapper(["measangleldtosw"], lang: :unicode)],
          asciimath: [["&#x29ab;"], parsing_wrapper(["measangleldtosw"], lang: :asciimath)],
          mathml: ["&#x29ab;"],
          latex: [["measangleldtosw", "&#x29ab;"]],
          omml: ["&#x29ab;"],
          html: ["&#x29ab;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\measangleldtosw"
        end

        def to_asciimath(**)
          parsing_wrapper("measangleldtosw", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29ab;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29ab;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29ab;"
        end

        def to_html(**)
          "&#x29ab;"
        end
      end
    end
  end
end
