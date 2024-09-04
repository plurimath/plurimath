module Plurimath
  module Math
    module Symbols
      class Lbrackextender < Symbol
        INPUT = {
          unicodemath: [["&#x23a2;"], parsing_wrapper(["lbrackextender"], lang: :unicode)],
          asciimath: [["&#x23a2;"], parsing_wrapper(["lbrackextender"], lang: :asciimath)],
          mathml: ["&#x23a2;"],
          latex: [["lbrackextender", "&#x23a2;"]],
          omml: ["&#x23a2;"],
          html: ["&#x23a2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lbrackextender"
        end

        def to_asciimath(**)
          parsing_wrapper("lbrackextender", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23a2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23a2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23a2;"
        end

        def to_html(**)
          "&#x23a2;"
        end
      end
    end
  end
end
