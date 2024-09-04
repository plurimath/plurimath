module Plurimath
  module Math
    module Symbols
      class Subedot < Symbol
        INPUT = {
          unicodemath: [["&#x2ac3;"], parsing_wrapper(["subedot"], lang: :unicode)],
          asciimath: [["&#x2ac3;"], parsing_wrapper(["subedot"], lang: :asciimath)],
          mathml: ["&#x2ac3;"],
          latex: [["subedot", "&#x2ac3;"]],
          omml: ["&#x2ac3;"],
          html: ["&#x2ac3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\subedot"
        end

        def to_asciimath(**)
          parsing_wrapper("subedot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ac3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ac3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ac3;"
        end

        def to_html(**)
          "&#x2ac3;"
        end
      end
    end
  end
end
