module Plurimath
  module Math
    module Symbols
      class Wedgebar < Symbol
        INPUT = {
          unicodemath: [["&#x2a5f;"], parsing_wrapper(["wedgebar"], lang: :unicode)],
          asciimath: [["&#x2a5f;"], parsing_wrapper(["wedgebar"], lang: :asciimath)],
          mathml: ["&#x2a5f;"],
          latex: [["wedgebar", "&#x2a5f;"]],
          omml: ["&#x2a5f;"],
          html: ["&#x2a5f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\wedgebar"
        end

        def to_asciimath(**)
          parsing_wrapper("wedgebar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a5f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a5f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a5f;"
        end

        def to_html(**)
          "&#x2a5f;"
        end
      end
    end
  end
end
