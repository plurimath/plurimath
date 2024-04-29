module Plurimath
  module Math
    module Symbols
      class Pushout < Symbol
        INPUT = {
          unicodemath: [["&#x27d4;"], parsing_wrapper(["pushout"])],
          asciimath: [["&#x27d4;"], parsing_wrapper(["pushout"])],
          mathml: ["&#x27d4;"],
          latex: [["pushout", "&#x27d4;"]],
          omml: ["&#x27d4;"],
          html: ["&#x27d4;"],
        }.freeze

        # output methods
        def to_latex
          "\\pushout"
        end

        def to_asciimath
          parsing_wrapper("pushout")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x27d4;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x27d4;"
        end

        def to_omml_without_math_tag(_)
          "&#x27d4;"
        end

        def to_html
          "&#x27d4;"
        end
      end
    end
  end
end
