module Plurimath
  module Math
    module Symbols
      class Percent < Symbol
        INPUT = {
          unicodemath: [["&#x25;"], parsing_wrapper(["%", "percent"], lang: :unicode)],
          asciimath: [["%", "&#x25;"], parsing_wrapper(["percent"], lang: :asciimath)],
          mathml: ["&#x25;"],
          latex: [["percent", "%", "&#x25;"]],
          omml: ["&#x25;"],
          html: ["&#x25;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\percent"
        end

        def to_asciimath(**)
          "%"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25;"
        end

        def to_html(**)
          "&#x25;"
        end
      end
    end
  end
end
