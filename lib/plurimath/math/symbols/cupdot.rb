module Plurimath
  module Math
    module Symbols
      class Cupdot < Symbol
        INPUT = {
          unicodemath: [["&#x228d;"], parsing_wrapper(["cupdot"], lang: :unicode)],
          asciimath: [["&#x228d;"], parsing_wrapper(["cupdot"], lang: :asciimath)],
          mathml: ["&#x228d;"],
          latex: [["cupdot", "&#x228d;"]],
          omml: ["&#x228d;"],
          html: ["&#x228d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\cupdot"
        end

        def to_asciimath(**)
          parsing_wrapper("cupdot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x228d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x228d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x228d;"
        end

        def to_html(**)
          "&#x228d;"
        end
      end
    end
  end
end
