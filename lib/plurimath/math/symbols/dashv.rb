module Plurimath
  module Math
    module Symbols
      class Dashv < Symbol
        INPUT = {
          unicodemath: [["&#x2ae5;"], parsing_wrapper(["DashV"])],
          asciimath: [["&#x2ae5;"], parsing_wrapper(["DashV"])],
          mathml: ["&#x2ae5;"],
          latex: [["DashV", "&#x2ae5;"]],
          omml: ["&#x2ae5;"],
          html: ["&#x2ae5;"],
        }.freeze

        # output methods
        def to_latex
          "\\DashV"
        end

        def to_asciimath
          parsing_wrapper("DashV")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2ae5;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2ae5;"
        end

        def to_omml_without_math_tag(_)
          "&#x2ae5;"
        end

        def to_html
          "&#x2ae5;"
        end
      end
    end
  end
end
