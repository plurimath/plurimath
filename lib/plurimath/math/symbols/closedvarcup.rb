module Plurimath
  module Math
    module Symbols
      class Closedvarcup < Symbol
        INPUT = {
          unicodemath: [["&#x2a4c;"], parsing_wrapper(["closedvarcup"], lang: :unicode)],
          asciimath: [["&#x2a4c;"], parsing_wrapper(["closedvarcup"], lang: :asciimath)],
          mathml: ["&#x2a4c;"],
          latex: [["closedvarcup", "&#x2a4c;"]],
          omml: ["&#x2a4c;"],
          html: ["&#x2a4c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\closedvarcup"
        end

        def to_asciimath(**)
          parsing_wrapper("closedvarcup", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a4c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a4c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a4c;"
        end

        def to_html(**)
          "&#x2a4c;"
        end
      end
    end
  end
end
