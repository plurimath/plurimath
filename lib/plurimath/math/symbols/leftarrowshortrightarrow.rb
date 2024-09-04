module Plurimath
  module Math
    module Symbols
      class Leftarrowshortrightarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2943;"], parsing_wrapper(["leftarrowshortrightarrow"], lang: :unicode)],
          asciimath: [["&#x2943;"], parsing_wrapper(["leftarrowshortrightarrow"], lang: :asciimath)],
          mathml: ["&#x2943;"],
          latex: [["leftarrowshortrightarrow", "&#x2943;"]],
          omml: ["&#x2943;"],
          html: ["&#x2943;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftarrowshortrightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("leftarrowshortrightarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2943;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2943;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2943;"
        end

        def to_html(**)
          "&#x2943;"
        end
      end
    end
  end
end
