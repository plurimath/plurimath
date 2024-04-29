module Plurimath
  module Math
    module Symbols
      class Langledot < Symbol
        INPUT = {
          unicodemath: [["&#x2991;"], parsing_wrapper(["langledot"])],
          asciimath: [["&#x2991;"], parsing_wrapper(["langledot"])],
          mathml: ["&#x2991;"],
          latex: [["langledot", "&#x2991;"]],
          omml: ["&#x2991;"],
          html: ["&#x2991;"],
        }.freeze

        # output methods
        def to_latex
          "\\langledot"
        end

        def to_asciimath
          parsing_wrapper("langledot")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2991;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2991;"
        end

        def to_omml_without_math_tag(_)
          "&#x2991;"
        end

        def to_html
          "&#x2991;"
        end
      end
    end
  end
end
