module Plurimath
  module Math
    module Symbols
      class Approx < Symbol
        INPUT = {
          unicodemath: [["approx", "&#x2248;"], parsing_wrapper(["~~"], lang: :unicode)],
          asciimath: [["approx", "~~", "&#x2248;"]],
          mathml: ["&#x2248;"],
          latex: [["approx", "&#x2248;"], parsing_wrapper(["~~"], lang: :latex)],
          omml: ["&#x2248;"],
          html: ["&#x2248;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\approx"
        end

        def to_asciimath(**)
          "approx"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2248;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x2248;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2248;"
        end

        def to_html(**)
          "&#x2248;"
        end
      end
    end
  end
end
