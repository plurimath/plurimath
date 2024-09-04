module Plurimath
  module Math
    module Symbols
      class Blackcircledrightdot < Symbol
        INPUT = {
          unicodemath: [["&#x2688;"], parsing_wrapper(["blackcircledrightdot"], lang: :unicode)],
          asciimath: [["&#x2688;"], parsing_wrapper(["blackcircledrightdot"], lang: :asciimath)],
          mathml: ["&#x2688;"],
          latex: [["blackcircledrightdot", "&#x2688;"]],
          omml: ["&#x2688;"],
          html: ["&#x2688;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blackcircledrightdot"
        end

        def to_asciimath(**)
          parsing_wrapper("blackcircledrightdot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2688;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2688;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2688;"
        end

        def to_html(**)
          "&#x2688;"
        end
      end
    end
  end
end
