module Plurimath
  module Math
    module Symbols
      class Circleonrightarrow < Symbol
        INPUT = {
          unicodemath: [["&#x21f4;"], parsing_wrapper(["circleonrightarrow"], lang: :unicode)],
          asciimath: [["&#x21f4;"], parsing_wrapper(["circleonrightarrow"], lang: :asciimath)],
          mathml: ["&#x21f4;"],
          latex: [["circleonrightarrow", "&#x21f4;"]],
          omml: ["&#x21f4;"],
          html: ["&#x21f4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circleonrightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("circleonrightarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21f4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21f4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21f4;"
        end

        def to_html(**)
          "&#x21f4;"
        end
      end
    end
  end
end
