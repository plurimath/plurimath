module Plurimath
  module Math
    module Symbols
      class UpcaseDelta < Symbol
        INPUT = {
          unicodemath: [["Delta", "&#x394;"]],
          asciimath: [["Delta", "&#x394;"]],
          mathml: ["&#x394;"],
          latex: [["Delta", "&#x394;"]],
          omml: ["&#x394;"],
          html: ["&#x394;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Delta"
        end

        def to_asciimath(**)
          "Delta"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x394;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x394;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x394;"
        end

        def to_html(**)
          "&#x394;"
        end
      end
    end
  end
end
