module Plurimath
  module Math
    module Symbols
      class Closedvarcupsmashprod < Symbol
        INPUT = {
          unicodemath: [["&#x2a50;"], parsing_wrapper(["closedvarcupsmashprod"], lang: :unicode)],
          asciimath: [["&#x2a50;"], parsing_wrapper(["closedvarcupsmashprod"], lang: :asciimath)],
          mathml: ["&#x2a50;"],
          latex: [["closedvarcupsmashprod", "&#x2a50;"]],
          omml: ["&#x2a50;"],
          html: ["&#x2a50;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\closedvarcupsmashprod"
        end

        def to_asciimath(**)
          parsing_wrapper("closedvarcupsmashprod", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a50;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a50;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a50;"
        end

        def to_html(**)
          "&#x2a50;"
        end
      end
    end
  end
end
