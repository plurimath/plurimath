module Plurimath
  module Math
    module Symbols
      class Frown < Symbol
        INPUT = {
          unicodemath: [["frown", "&#x2322;"]],
          asciimath: [["frown", "&#x2322;"]],
          mathml: ["&#x2322;"],
          latex: [["frown", "&#x2322;"]],
          omml: ["&#x2322;"],
          html: ["&#x2322;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\frown"
        end

        def to_asciimath(**)
          "frown"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2322;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2322;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2322;"
        end

        def to_html(**)
          "&#x2322;"
        end
      end
    end
  end
end
