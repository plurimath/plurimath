module Plurimath
  module Math
    module Symbols
      class Oo < Symbol
        INPUT = {
          unicodemath: [["infty", "oo", "&#x221e;"]],
          asciimath: [["infty", "oo", "&#x221e;"]],
          mathml: ["&#x221e;"],
          latex: [["infty", "&#x221e;"], parsing_wrapper(["oo"], lang: :latex)],
          omml: ["&#x221e;"],
          html: ["&#x221e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\infty"
        end

        def to_asciimath(**)
          "oo"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x221e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x221e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x221e;"
        end

        def to_html(**)
          "&#x221e;"
        end
      end
    end
  end
end
