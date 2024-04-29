module Plurimath
  module Math
    module Symbols
      class Rvboxline < Symbol
        INPUT = {
          unicodemath: [["&#x23b9;"], parsing_wrapper(["rvboxline"])],
          asciimath: [["&#x23b9;"], parsing_wrapper(["rvboxline"])],
          mathml: ["&#x23b9;"],
          latex: [["rvboxline", "&#x23b9;"]],
          omml: ["&#x23b9;"],
          html: ["&#x23b9;"],
        }.freeze

        # output methods
        def to_latex
          "\\rvboxline"
        end

        def to_asciimath
          parsing_wrapper("rvboxline")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x23b9;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x23b9;"
        end

        def to_omml_without_math_tag(_)
          "&#x23b9;"
        end

        def to_html
          "&#x23b9;"
        end
      end
    end
  end
end
