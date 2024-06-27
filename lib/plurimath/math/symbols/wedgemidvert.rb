module Plurimath
  module Math
    module Symbols
      class Wedgemidvert < Symbol
        INPUT = {
          unicodemath: [["&#x2a5a;"], parsing_wrapper(["wedgemidvert"])],
          asciimath: [["&#x2a5a;"], parsing_wrapper(["wedgemidvert"])],
          mathml: ["&#x2a5a;"],
          latex: [["wedgemidvert", "&#x2a5a;"]],
          omml: ["&#x2a5a;"],
          html: ["&#x2a5a;"],
        }.freeze

        # output methods
        def to_latex
          "\\wedgemidvert"
        end

        def to_asciimath
          parsing_wrapper("wedgemidvert")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a5a;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mi") << "&#x2a5a;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a5a;"
        end

        def to_html
          "&#x2a5a;"
        end
      end
    end
  end
end
