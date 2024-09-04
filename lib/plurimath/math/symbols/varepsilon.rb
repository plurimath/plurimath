module Plurimath
  module Math
    module Symbols
      class Varepsilon < Symbol
        INPUT = {
          unicodemath: ["&#x25b;", "varepsilon"],
          asciimath: ["varepsilon", "&#x25b;"],
          mathml: ["&#x25b;"],
          latex: ["varepsilon", "&#x25b;"],
          omml: ["&#x25b;"],
          html: ["&#x25b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varepsilon"
        end

        def to_asciimath(**)
          "varepsilon"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25b;"
        end

        def to_html(**)
          "&#x25b;"
        end
      end
    end
  end
end
