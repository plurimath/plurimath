module Plurimath
  module Math
    module Symbols
      class Rbrackextender < Symbol
        INPUT = {
          unicodemath: [["&#x23a5;"], parsing_wrapper(["rbrackextender"], lang: :unicode)],
          asciimath: [["&#x23a5;"], parsing_wrapper(["rbrackextender"], lang: :asciimath)],
          mathml: ["&#x23a5;"],
          latex: [["rbrackextender", "&#x23a5;"]],
          omml: ["&#x23a5;"],
          html: ["&#x23a5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rbrackextender"
        end

        def to_asciimath(**)
          parsing_wrapper("rbrackextender", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23a5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23a5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23a5;"
        end

        def to_html(**)
          "&#x23a5;"
        end
      end
    end
  end
end
