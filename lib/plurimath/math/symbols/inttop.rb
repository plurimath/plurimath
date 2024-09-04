module Plurimath
  module Math
    module Symbols
      class Inttop < Symbol
        INPUT = {
          unicodemath: [["&#x2320;"], parsing_wrapper(["inttop"], lang: :unicode)],
          asciimath: [["&#x2320;"], parsing_wrapper(["inttop"], lang: :asciimath)],
          mathml: ["&#x2320;"],
          latex: [["inttop", "&#x2320;"]],
          omml: ["&#x2320;"],
          html: ["&#x2320;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\inttop"
        end

        def to_asciimath(**)
          parsing_wrapper("inttop", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2320;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2320;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2320;"
        end

        def to_html(**)
          "&#x2320;"
        end
      end
    end
  end
end
