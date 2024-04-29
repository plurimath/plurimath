module Plurimath
  module Math
    module Symbols
      class Lllnest < Symbol
        INPUT = {
          unicodemath: [["&#x2af7;"], parsing_wrapper(["lllnest"])],
          asciimath: [["&#x2af7;"], parsing_wrapper(["lllnest"])],
          mathml: ["&#x2af7;"],
          latex: [["lllnest", "&#x2af7;"]],
          omml: ["&#x2af7;"],
          html: ["&#x2af7;"],
        }.freeze

        # output methods
        def to_latex
          "\\lllnest"
        end

        def to_asciimath
          parsing_wrapper("lllnest")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2af7;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2af7;"
        end

        def to_omml_without_math_tag(_)
          "&#x2af7;"
        end

        def to_html
          "&#x2af7;"
        end
      end
    end
  end
end
