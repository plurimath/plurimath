module Plurimath
  module Math
    module Symbols
      class Circledownarrow < Symbol
        INPUT = {
          unicodemath: [["&#x29ec;"], parsing_wrapper(["circledownarrow"], lang: :unicode)],
          asciimath: [["&#x29ec;"], parsing_wrapper(["circledownarrow"], lang: :asciimath)],
          mathml: ["&#x29ec;"],
          latex: [["circledownarrow", "&#x29ec;"]],
          omml: ["&#x29ec;"],
          html: ["&#x29ec;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circledownarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("circledownarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29ec;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29ec;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29ec;"
        end

        def to_html(**)
          "&#x29ec;"
        end
      end
    end
  end
end
