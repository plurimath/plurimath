module Plurimath
  module Math
    module Symbols
      class Updownarrow < Symbol
        INPUT = {
          unicodemath: [["Updownarrow", "&#x21d5;"]],
          asciimath: [["&#x21d5;"], parsing_wrapper(["Updownarrow"], lang: :asciimath)],
          mathml: ["&#x21d5;"],
          latex: [["Updownarrow", "&#x21d5;"]],
          omml: ["&#x21d5;"],
          html: ["&#x21d5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Updownarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("Updownarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21d5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21d5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21d5;"
        end

        def to_html(**)
          "&#x21d5;"
        end
      end
    end
  end
end
