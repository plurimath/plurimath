module Plurimath
  module Math
    module Symbols
      class Vbar < Symbol
        INPUT = {
          unicodemath: [["vbar", "&#x2502;"]],
          asciimath: [["&#x2502;"], parsing_wrapper(["vbar"])],
          mathml: ["&#x2502;"],
          latex: [["&#x2502;"], parsing_wrapper(["vbar"])],
          omml: ["&#x2502;"],
          html: ["&#x2502;"],
        }.freeze

        # output methods
        def to_latex
          parsing_wrapper("vbar")
        end

        def to_asciimath
          parsing_wrapper("vbar")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2502;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2502;"
        end

        def to_omml_without_math_tag(_)
          "&#x2502;"
        end

        def to_html
          "&#x2502;"
        end
      end
    end
  end
end
