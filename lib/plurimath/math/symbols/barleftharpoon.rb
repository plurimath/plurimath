module Plurimath
  module Math
    module Symbols
      class Barleftharpoon < Symbol
        INPUT = {
          unicodemath: [["&#x296b;"], parsing_wrapper(["dashleftharpoondown", "barleftharpoon"])],
          asciimath: [["&#x296b;"], parsing_wrapper(["dashleftharpoondown", "barleftharpoon"])],
          mathml: ["&#x296b;"],
          latex: [["dashleftharpoondown", "barleftharpoon", "&#x296b;"]],
          omml: ["&#x296b;"],
          html: ["&#x296b;"],
        }.freeze

        # output methods
        def to_latex
          "\\dashleftharpoondown"
        end

        def to_asciimath
          parsing_wrapper("barleftharpoon")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x296b;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x296b;"
        end

        def to_omml_without_math_tag(_)
          "&#x296b;"
        end

        def to_html
          "&#x296b;"
        end
      end
    end
  end
end
