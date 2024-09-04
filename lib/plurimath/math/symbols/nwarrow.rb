module Plurimath
  module Math
    module Symbols
      class Nwarrow < Symbol
        INPUT = {
          unicodemath: [["&#x21d6;"], parsing_wrapper(["Nwarrow"], lang: :unicode)],
          asciimath: [["&#x21d6;"], parsing_wrapper(["Nwarrow"], lang: :asciimath)],
          mathml: ["&#x21d6;"],
          latex: [["Nwarrow", "&#x21d6;"]],
          omml: ["&#x21d6;"],
          html: ["&#x21d6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Nwarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("Nwarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21d6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21d6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21d6;"
        end

        def to_html(**)
          "&#x21d6;"
        end
      end
    end
  end
end
