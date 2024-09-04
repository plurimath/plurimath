module Plurimath
  module Math
    module Symbols
      class Euro < Symbol
        INPUT = {
          unicodemath: [["&#x20ac;"], parsing_wrapper(["euro"], lang: :unicode)],
          asciimath: [["&#x20ac;"], parsing_wrapper(["euro"], lang: :asciimath)],
          mathml: ["&#x20ac;"],
          latex: [["euro", "&#x20ac;"]],
          omml: ["&#x20ac;"],
          html: ["&#x20ac;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\euro"
        end

        def to_asciimath(**)
          parsing_wrapper("euro", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x20ac;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x20ac;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x20ac;"
        end

        def to_html(**)
          "&#x20ac;"
        end
      end
    end
  end
end
