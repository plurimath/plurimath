module Plurimath
  module Math
    module Symbols
      class Ltimes < Symbol
        INPUT = {
          unicodemath: [["ltimes", "&#x22c9;"], parsing_wrapper(["|><"], lang: :unicode)],
          asciimath: [["ltimes", "|><", "&#x22c9;"]],
          mathml: ["&#x22c9;"],
          latex: [["ltimes", "&#x22c9;"], parsing_wrapper(["|><"], lang: :latex)],
          omml: ["&#x22c9;"],
          html: ["&#x22c9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ltimes"
        end

        def to_asciimath(**)
          "ltimes"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22c9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22c9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22c9;"
        end

        def to_html(**)
          "&#x22c9;"
        end
      end
    end
  end
end
