module Plurimath
  module Math
    module Symbols
      class Equal < Symbol
        INPUT = {
          unicodemath: [["&#x3d;", "="], parsing_wrapper(["equal"], lang: :unicode)],
          asciimath: [["=", "&#x3d;"], parsing_wrapper(["equal"], lang: :asciimath)],
          mathml: ["&#x3d;", "="],
          latex: [["equal", "=", "&#x3d;"]],
          omml: ["&#x3d;", "="],
          html: ["&#x3d;", "="],
        }.freeze

        # output methods
        def to_latex(**)
          "="
        end

        def to_asciimath(**)
          "="
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("=")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "="
        end

        def to_omml_without_math_tag(_, **)
          "="
        end

        def to_html(**)
          "="
        end
      end
    end
  end
end
