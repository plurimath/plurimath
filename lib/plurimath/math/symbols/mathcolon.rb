module Plurimath
  module Math
    module Symbols
      class Mathcolon < Symbol
        INPUT = {
          unicodemath: [["&#x3a;"], parsing_wrapper([":", "mathcolon", "colon"], lang: :unicode)],
          asciimath: [[":", "&#x3a;"], parsing_wrapper(["mathcolon", "colon"], lang: :asciimath)],
          mathml: ["&#x3a;"],
          latex: [["mathcolon", "colon", ":", "&#x3a;"]],
          omml: ["&#x3a;"],
          html: ["&#x3a;"],
        }.freeze

        # output methods
        def to_latex(**)
          ":"
        end

        def to_asciimath(**)
          ":"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x3a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3a;"
        end

        def to_html(**)
          "&#x3a;"
        end
      end
    end
  end
end
