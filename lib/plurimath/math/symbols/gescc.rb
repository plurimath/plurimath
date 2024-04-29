module Plurimath
  module Math
    module Symbols
      class Gescc < Symbol
        INPUT = {
          unicodemath: [["&#x2aa9;"], parsing_wrapper(["gescc"])],
          asciimath: [["&#x2aa9;"], parsing_wrapper(["gescc"])],
          mathml: ["&#x2aa9;"],
          latex: [["gescc", "&#x2aa9;"]],
          omml: ["&#x2aa9;"],
          html: ["&#x2aa9;"],
        }.freeze

        # output methods
        def to_latex
          "\\gescc"
        end

        def to_asciimath
          parsing_wrapper("gescc")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2aa9;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2aa9;"
        end

        def to_omml_without_math_tag(_)
          "&#x2aa9;"
        end

        def to_html
          "&#x2aa9;"
        end
      end
    end
  end
end
