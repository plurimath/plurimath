module Plurimath
  module Math
    module Symbols
      class Radiation < Symbol
        INPUT = {
          unicodemath: [["&#x2622;"], parsing_wrapper(["radiation"])],
          asciimath: [["&#x2622;"], parsing_wrapper(["radiation"])],
          mathml: ["&#x2622;"],
          latex: [["radiation", "&#x2622;"]],
          omml: ["&#x2622;"],
          html: ["&#x2622;"],
        }.freeze

        # output methods
        def to_latex
          "\\radiation"
        end

        def to_asciimath
          parsing_wrapper("radiation")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2622;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2622;"
        end

        def to_omml_without_math_tag(_)
          "&#x2622;"
        end

        def to_html
          "&#x2622;"
        end
      end
    end
  end
end
