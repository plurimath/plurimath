module Plurimath
  module Math
    module Symbols
      class Nis < Symbol
        INPUT = {
          unicodemath: [["&#x22fc;"], parsing_wrapper(["nis"])],
          asciimath: [["&#x22fc;"], parsing_wrapper(["nis"])],
          mathml: ["&#x22fc;"],
          latex: [["nis", "&#x22fc;"]],
          omml: ["&#x22fc;"],
          html: ["&#x22fc;"],
        }.freeze

        # output methods
        def to_latex
          "\\nis"
        end

        def to_asciimath
          parsing_wrapper("nis")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x22fc;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x22fc;"
        end

        def to_omml_without_math_tag(_)
          "&#x22fc;"
        end

        def to_html
          "&#x22fc;"
        end
      end
    end
  end
end
