module Plurimath
  module Math
    module Symbols
      class Whtvertoval < Symbol
        INPUT = {
          unicodemath: [["&#x2b2f;"], parsing_wrapper(["whtvertoval"], lang: :unicode)],
          asciimath: [["&#x2b2f;"], parsing_wrapper(["whtvertoval"], lang: :asciimath)],
          mathml: ["&#x2b2f;"],
          latex: [["whtvertoval", "&#x2b2f;"]],
          omml: ["&#x2b2f;"],
          html: ["&#x2b2f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\whtvertoval"
        end

        def to_asciimath(**)
          parsing_wrapper("whtvertoval", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b2f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b2f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b2f;"
        end

        def to_html(**)
          "&#x2b2f;"
        end
      end
    end
  end
end
