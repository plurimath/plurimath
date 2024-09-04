module Plurimath
  module Math
    module Symbols
      class Ddots < Symbol
        INPUT = {
          unicodemath: [["ddots", "&#x22f1;"]],
          asciimath: [["ddots", "&#x22f1;"]],
          mathml: ["&#x22f1;"],
          latex: [["ddots", "&#x22f1;"]],
          omml: ["&#x22f1;"],
          html: ["&#x22f1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ddots"
        end

        def to_asciimath(**)
          "ddots"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22f1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x22f1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22f1;"
        end

        def to_html(**)
          "&#x22f1;"
        end
      end
    end
  end
end
