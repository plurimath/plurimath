module Plurimath
  module Math
    module Symbols
      class Mathslash < Symbol
        INPUT = {
          unicodemath: [["&#x2f;"], parsing_wrapper(["//", "mathslash"], lang: :unicode)],
          asciimath: [["//", "&#x2f;"], parsing_wrapper(["mathslash"], lang: :asciimath)],
          mathml: ["&#x2f;"],
          latex: ["mathslash", "//", "&#x2f;"],
          omml: ["&#x2f;"],
          html: ["&#x2f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "/"
        end

        def to_asciimath(**)
          "//"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("/")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "/"
        end

        def to_omml_without_math_tag(_, **)
          "/"
        end

        def to_html(**)
          "/"
        end
      end
    end
  end
end
