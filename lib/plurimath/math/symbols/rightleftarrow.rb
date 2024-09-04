module Plurimath
  module Math
    module Symbols
      class Rightleftarrow < Symbol
        INPUT = {
          unicodemath: [["rightleftarrows", "&#x21c4;"], parsing_wrapper(["rightleftarrow"], lang: :unicode)],
          asciimath: [["&#x21c4;"], parsing_wrapper(["rightleftarrows", "rightleftarrow"], lang: :asciimath)],
          mathml: ["&#x21c4;"],
          latex: [["rightleftarrows", "rightleftarrow", "&#x21c4;"]],
          omml: ["&#x21c4;"],
          html: ["&#x21c4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightleftarrows"
        end

        def to_asciimath(**)
          parsing_wrapper("rightleftarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21c4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21c4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21c4;"
        end

        def to_html(**)
          "&#x21c4;"
        end
      end
    end
  end
end
