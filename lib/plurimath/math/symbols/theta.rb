module Plurimath
  module Math
    module Symbols
      class Theta < Symbol
        INPUT = {
          unicodemath: ["theta", "&#x3b8;", "&#x1d703;", parsing_wrapper(["uptheta"], lang: :unicode)],
          asciimath: ["theta", "&#x3b8;", "&#x1d703;", parsing_wrapper(["uptheta"], lang: :asciimath)],
          mathml: ["&#x3b8;", "&#x1d703;"],
          latex: ["uptheta", "theta", "&#x3b8;", "&#x1d703;"],
          omml: ["&#x3b8;", "&#x1d703;"],
          html: ["&#x3b8;", "&#x1d703;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\theta"
        end

        def to_asciimath(**)
          "theta"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3b8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3b8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3b8;"
        end

        def to_html(**)
          "&#x3b8;"
        end
      end
    end
  end
end
