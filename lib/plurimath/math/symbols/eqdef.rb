module Plurimath
  module Math
    module Symbols
      class Eqdef < Symbol
        INPUT = {
          unicodemath: [["&#x225d;"], parsing_wrapper(["eqdef"], lang: :unicode)],
          asciimath: [["&#x225d;"], parsing_wrapper(["eqdef"], lang: :asciimath)],
          mathml: ["&#x225d;"],
          latex: [["eqdef", "&#x225d;"]],
          omml: ["&#x225d;"],
          html: ["&#x225d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\eqdef"
        end

        def to_asciimath(**)
          parsing_wrapper("eqdef", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x225d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x225d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x225d;"
        end

        def to_html(**)
          "&#x225d;"
        end
      end
    end
  end
end
