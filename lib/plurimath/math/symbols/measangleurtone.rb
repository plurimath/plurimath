module Plurimath
  module Math
    module Symbols
      class Measangleurtone < Symbol
        INPUT = {
          unicodemath: [["&#x29ac;"], parsing_wrapper(["measangleurtone"], lang: :unicode)],
          asciimath: [["&#x29ac;"], parsing_wrapper(["measangleurtone"], lang: :asciimath)],
          mathml: ["&#x29ac;"],
          latex: [["measangleurtone", "&#x29ac;"]],
          omml: ["&#x29ac;"],
          html: ["&#x29ac;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\measangleurtone"
        end

        def to_asciimath(**)
          parsing_wrapper("measangleurtone", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29ac;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29ac;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29ac;"
        end

        def to_html(**)
          "&#x29ac;"
        end
      end
    end
  end
end
