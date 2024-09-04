module Plurimath
  module Math
    module Symbols
      class Aleph < Symbol
        INPUT = {
          unicodemath: [["aleph", "&#x2135;"]],
          asciimath: [["aleph", "&#x2135;"]],
          mathml: ["&#x2135;"],
          latex: [["aleph", "&#x2135;"]],
          omml: ["&#x2135;"],
          html: ["&#x2135;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\aleph"
        end

        def to_asciimath(**)
          "aleph"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2135;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2135;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2135;"
        end

        def to_html(**)
          "&#x2135;"
        end
      end
    end
  end
end
