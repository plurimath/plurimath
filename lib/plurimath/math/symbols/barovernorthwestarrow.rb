module Plurimath
  module Math
    module Symbols
      class Barovernorthwestarrow < Symbol
        INPUT = {
          unicodemath: [["&#x21b8;"], parsing_wrapper(["barovernorthwestarrow"], lang: :unicode)],
          asciimath: [["&#x21b8;"], parsing_wrapper(["barovernorthwestarrow"], lang: :asciimath)],
          mathml: ["&#x21b8;"],
          latex: [["barovernorthwestarrow", "&#x21b8;"]],
          omml: ["&#x21b8;"],
          html: ["&#x21b8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\barovernorthwestarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("barovernorthwestarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21b8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21b8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21b8;"
        end

        def to_html(**)
          "&#x21b8;"
        end
      end
    end
  end
end
