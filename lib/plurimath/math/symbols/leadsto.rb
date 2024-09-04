module Plurimath
  module Math
    module Symbols
      class Leadsto < Symbol
        INPUT = {
          unicodemath: [["&#x2933;"], parsing_wrapper(["rightcurvedarrow", "leadsto"], lang: :unicode)],
          asciimath: [["&#x2933;"], parsing_wrapper(["rightcurvedarrow", "leadsto"], lang: :asciimath)],
          mathml: ["&#x2933;"],
          latex: [["rightcurvedarrow", "leadsto", "&#x2933;"]],
          omml: ["&#x2933;"],
          html: ["&#x2933;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leadsto"
        end

        def to_asciimath(**)
          "leadsto"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2933;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2933;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2933;"
        end

        def to_html(**)
          "&#x2933;"
        end
      end
    end
  end
end
