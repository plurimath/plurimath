module Plurimath
  module Math
    module Symbols
      class Nin < Symbol
        INPUT = {
          unicodemath: [["notin", "&#x2209;"], parsing_wrapper(["!in", "nin"], lang: :unicode)],
          asciimath: [["notin", "!in", "&#x2209;"], parsing_wrapper(["nin"], lang: :asciimath)],
          mathml: ["&#x2209;"],
          latex: [["notin", "nin", "&#x2209;"], parsing_wrapper(["!in"], lang: :latex)],
          omml: ["&#x2209;"],
          html: ["&#x2209;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\notin"
        end

        def to_asciimath(**)
          parsing_wrapper("nin", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2209;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2209;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2209;"
        end

        def to_html(**)
          "&#x2209;"
        end
      end
    end
  end
end
