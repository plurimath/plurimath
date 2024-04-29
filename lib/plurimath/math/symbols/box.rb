module Plurimath
  module Math
    module Symbols
      class Box < Symbol
        INPUT = {
          unicodemath: [["box", "&#x25a1;"], parsing_wrapper(["square", "mdlgwhtsquare"])],
          asciimath: [["square", "&#x25a1;"], parsing_wrapper(["box", "mdlgwhtsquare"])],
          mathml: ["&#x25a1;"],
          latex: [["mdlgwhtsquare", "&#x25a1;"], parsing_wrapper(["box", "square"])],
          omml: ["&#x25a1;"],
          html: ["&#x25a1;"],
        }.freeze

        # output methods
        def to_latex
          "\\mdlgwhtsquare"
        end

        def to_asciimath
          parsing_wrapper("box")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x25a1;")
        end

        def to_mathml_without_math_tag
          ox_element("mo") << "&#x25a1;"
        end

        def to_omml_without_math_tag(_)
          "&#x25a1;"
        end

        def to_html
          "&#x25a1;"
        end
      end
    end
  end
end
