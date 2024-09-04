module Plurimath
  module Math
    module Symbols
      class Doubleplus < Symbol
        INPUT = {
          unicodemath: [["&#x29fa;"], parsing_wrapper(["doubleplus"], lang: :unicode)],
          asciimath: [["&#x29fa;"], parsing_wrapper(["doubleplus"], lang: :asciimath)],
          mathml: ["&#x29fa;"],
          latex: [["doubleplus", "&#x29fa;"]],
          omml: ["&#x29fa;"],
          html: ["&#x29fa;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\doubleplus"
        end

        def to_asciimath(**)
          parsing_wrapper("doubleplus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29fa;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29fa;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29fa;"
        end

        def to_html(**)
          "&#x29fa;"
        end
      end
    end
  end
end
