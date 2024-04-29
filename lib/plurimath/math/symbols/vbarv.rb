module Plurimath
  module Math
    module Symbols
      class Vbarv < Symbol
        INPUT = {
          unicodemath: [["&#x2ae9;"], parsing_wrapper(["vBarv"])],
          asciimath: [["&#x2ae9;"], parsing_wrapper(["vBarv"])],
          mathml: ["&#x2ae9;"],
          latex: [["vBarv", "&#x2ae9;"]],
          omml: ["&#x2ae9;"],
          html: ["&#x2ae9;"],
        }.freeze

        # output methods
        def to_latex
          "\\vBarv"
        end

        def to_asciimath
          parsing_wrapper("vBarv")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2ae9;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2ae9;"
        end

        def to_omml_without_math_tag(_)
          "&#x2ae9;"
        end

        def to_html
          "&#x2ae9;"
        end
      end
    end
  end
end
