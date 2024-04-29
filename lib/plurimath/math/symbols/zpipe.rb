module Plurimath
  module Math
    module Symbols
      class Zpipe < Symbol
        INPUT = {
          unicodemath: [["&#x2a20;"], parsing_wrapper(["zpipe"])],
          asciimath: [["&#x2a20;"], parsing_wrapper(["zpipe"])],
          mathml: ["&#x2a20;"],
          latex: [["zpipe", "&#x2a20;"]],
          omml: ["&#x2a20;"],
          html: ["&#x2a20;"],
        }.freeze

        # output methods
        def to_latex
          "\\zpipe"
        end

        def to_asciimath
          parsing_wrapper("zpipe")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2a20;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2a20;"
        end

        def to_omml_without_math_tag(_)
          "&#x2a20;"
        end

        def to_html
          "&#x2a20;"
        end
      end
    end
  end
end
