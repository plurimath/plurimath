module Plurimath
  module Math
    module Symbols
      class Upiota < Symbol
        INPUT = {
          unicodemath: [["&#x399;"], parsing_wrapper(["upIota"], lang: :unicode)],
          asciimath: [["&#x399;"], parsing_wrapper(["upIota"], lang: :asciimath)],
          mathml: ["&#x399;"],
          latex: [["upIota", "&#x399;"]],
          omml: ["&#x399;"],
          html: ["&#x399;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upIota"
        end

        def to_asciimath(**)
          parsing_wrapper("upIota", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x399;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x399;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x399;"
        end

        def to_html(**)
          "&#x399;"
        end
      end
    end
  end
end
