module Plurimath
  module Math
    module Symbols
      class Underbar < Symbol
        INPUT = {
          unicodemath: [["&#x331;"], parsing_wrapper(["underbar"], lang: :unicode)],
          asciimath: [["&#x331;"], parsing_wrapper(["underbar"], lang: :asciimath)],
          mathml: ["&#x331;"],
          latex: [["underbar", "&#x331;"]],
          omml: ["&#x331;"],
          html: ["&#x331;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\underbar"
        end

        def to_asciimath(**)
          parsing_wrapper("underbar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x331;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x331;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x331;"
        end

        def to_html(**)
          "&#x331;"
        end
      end
    end
  end
end
