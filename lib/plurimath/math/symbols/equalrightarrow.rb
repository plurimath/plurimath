module Plurimath
  module Math
    module Symbols
      class Equalrightarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2971;"], parsing_wrapper(["equalrightarrow"], lang: :unicode)],
          asciimath: [["&#x2971;"], parsing_wrapper(["equalrightarrow"], lang: :asciimath)],
          mathml: ["&#x2971;"],
          latex: [["equalrightarrow", "&#x2971;"]],
          omml: ["&#x2971;"],
          html: ["&#x2971;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\equalrightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("equalrightarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2971;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2971;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2971;"
        end

        def to_html(**)
          "&#x2971;"
        end
      end
    end
  end
end
