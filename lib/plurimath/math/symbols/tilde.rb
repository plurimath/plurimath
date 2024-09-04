module Plurimath
  module Math
    module Symbols
      class Tilde < Symbol
        INPUT = {
          unicodemath: [["~"]],
          asciimath: [["~"]],
          mathml: ["~"],
          latex: [["~"]],
          omml: ["~"],
          html: ["~"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\tilde"
        end

        def to_asciimath(**)
          "tilde"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x7e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x7e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x7e;"
        end

        def to_html(**)
          "~"
        end
      end
    end
  end
end
