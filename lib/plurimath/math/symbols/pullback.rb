module Plurimath
  module Math
    module Symbols
      class Pullback < Symbol
        INPUT = {
          unicodemath: [["&#x27d3;"], parsing_wrapper(["pullback"], lang: :unicode)],
          asciimath: [["&#x27d3;"], parsing_wrapper(["pullback"], lang: :asciimath)],
          mathml: ["&#x27d3;"],
          latex: [["pullback", "&#x27d3;"]],
          omml: ["&#x27d3;"],
          html: ["&#x27d3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\pullback"
        end

        def to_asciimath(**)
          parsing_wrapper("pullback", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27d3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27d3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27d3;"
        end

        def to_html(**)
          "&#x27d3;"
        end
      end
    end
  end
end
