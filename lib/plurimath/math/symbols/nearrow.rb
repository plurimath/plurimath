module Plurimath
  module Math
    module Symbols
      class Nearrow < Symbol
        INPUT = {
          unicodemath: [["&#x21d7;"], parsing_wrapper(["Nearrow"])],
          asciimath: [["&#x21d7;"], parsing_wrapper(["Nearrow"])],
          mathml: ["&#x21d7;"],
          latex: [["Nearrow", "&#x21d7;"]],
          omml: ["&#x21d7;"],
          html: ["&#x21d7;"],
        }.freeze

        # output methods
        def to_latex
          "\\Nearrow"
        end

        def to_asciimath
          parsing_wrapper("Nearrow")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x21d7;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x21d7;"
        end

        def to_omml_without_math_tag(_)
          "&#x21d7;"
        end

        def to_html
          "&#x21d7;"
        end
      end
    end
  end
end
