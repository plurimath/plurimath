module Plurimath
  module Math
    module Symbols
      class Upomicron < Symbol
        INPUT = {
          unicodemath: [["&#x3bf;"], parsing_wrapper(["upomicron"])],
          asciimath: [["&#x3bf;"], parsing_wrapper(["upomicron"])],
          mathml: ["&#x3bf;"],
          latex: [["upomicron", "&#x3bf;"]],
          omml: ["&#x3bf;"],
          html: ["&#x3bf;"],
        }.freeze

        # output methods
        def to_latex
          "\\upomicron"
        end

        def to_asciimath
          parsing_wrapper("upomicron")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x3bf;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x3bf;"
        end

        def to_omml_without_math_tag(_)
          "&#x3bf;"
        end

        def to_html
          "&#x3bf;"
        end
      end
    end
  end
end
