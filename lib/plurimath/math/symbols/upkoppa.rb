module Plurimath
  module Math
    module Symbols
      class Upkoppa < Symbol
        INPUT = {
          unicodemath: [["&#x3df;"], parsing_wrapper(["upkoppa"], lang: :unicode)],
          asciimath: [["&#x3df;"], parsing_wrapper(["upkoppa"], lang: :asciimath)],
          mathml: ["&#x3df;"],
          latex: [["upkoppa", "&#x3df;"]],
          omml: ["&#x3df;"],
          html: ["&#x3df;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upkoppa"
        end

        def to_asciimath(**)
          parsing_wrapper("upkoppa", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3df;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3df;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3df;"
        end

        def to_html(**)
          "&#x3df;"
        end
      end
    end
  end
end
