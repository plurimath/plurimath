module Plurimath
  module Math
    module Symbols
      class Closedvarcap < Symbol
        INPUT = {
          unicodemath: [["&#x2a4d;"], parsing_wrapper(["closedvarcap"], lang: :unicode)],
          asciimath: [["&#x2a4d;"], parsing_wrapper(["closedvarcap"], lang: :asciimath)],
          mathml: ["&#x2a4d;"],
          latex: [["closedvarcap", "&#x2a4d;"]],
          omml: ["&#x2a4d;"],
          html: ["&#x2a4d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\closedvarcap"
        end

        def to_asciimath(**)
          parsing_wrapper("closedvarcap", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a4d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a4d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a4d;"
        end

        def to_html(**)
          "&#x2a4d;"
        end
      end
    end
  end
end
