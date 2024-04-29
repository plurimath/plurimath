module Plurimath
  module Math
    module Symbols
      class Dasharrowright < Symbol
        INPUT = {
          unicodemath: [["dasharrowright", "&#x21eb;"]],
          asciimath: [["&#x21eb;"], parsing_wrapper(["dasharrowright"])],
          mathml: ["&#x21eb;"],
          latex: [["&#x21eb;"], parsing_wrapper(["dasharrowright"])],
          omml: ["&#x21eb;"],
          html: ["&#x21eb;"],
        }.freeze

        # output methods
        def to_latex
          parsing_wrapper("dasharrowright")
        end

        def to_asciimath
          parsing_wrapper("dasharrowright")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x21eb;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x21eb;"
        end

        def to_omml_without_math_tag(_)
          "&#x21eb;"
        end

        def to_html
          "&#x21eb;"
        end
      end
    end
  end
end
