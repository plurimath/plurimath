module Plurimath
  module Math
    module Symbols
      class Twocaps < Symbol
        INPUT = {
          unicodemath: [["&#x2a4b;"], parsing_wrapper(["twocaps"], lang: :unicode)],
          asciimath: [["&#x2a4b;"], parsing_wrapper(["twocaps"], lang: :asciimath)],
          mathml: ["&#x2a4b;"],
          latex: [["twocaps", "&#x2a4b;"]],
          omml: ["&#x2a4b;"],
          html: ["&#x2a4b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\twocaps"
        end

        def to_asciimath(**)
          parsing_wrapper("twocaps", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a4b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a4b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a4b;"
        end

        def to_html(**)
          "&#x2a4b;"
        end
      end
    end
  end
end
