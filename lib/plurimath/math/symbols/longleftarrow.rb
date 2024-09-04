module Plurimath
  module Math
    module Symbols
      class Longleftarrow < Symbol
        INPUT = {
          unicodemath: [["longleftarrow", "&#x27f5;"]],
          asciimath: [["&#x27f5;"], parsing_wrapper(["longleftarrow"], lang: :asciimath)],
          mathml: ["&#x27f5;"],
          latex: [["longleftarrow", "&#x27f5;"]],
          omml: ["&#x27f5;"],
          html: ["&#x27f5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\longleftarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("longleftarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27f5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27f5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27f5;"
        end

        def to_html(**)
          "&#x27f5;"
        end
      end
    end
  end
end
