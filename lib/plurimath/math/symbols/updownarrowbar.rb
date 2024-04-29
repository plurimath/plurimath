module Plurimath
  module Math
    module Symbols
      class Updownarrowbar < Symbol
        INPUT = {
          unicodemath: [["&#x21a8;"], parsing_wrapper(["updownarrowbar"])],
          asciimath: [["&#x21a8;"], parsing_wrapper(["updownarrowbar"])],
          mathml: ["&#x21a8;"],
          latex: [["updownarrowbar", "&#x21a8;"]],
          omml: ["&#x21a8;"],
          html: ["&#x21a8;"],
        }.freeze

        # output methods
        def to_latex
          "\\updownarrowbar"
        end

        def to_asciimath
          parsing_wrapper("updownarrowbar")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x21a8;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x21a8;"
        end

        def to_omml_without_math_tag(_)
          "&#x21a8;"
        end

        def to_html
          "&#x21a8;"
        end
      end
    end
  end
end
