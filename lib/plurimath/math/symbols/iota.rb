module Plurimath
  module Math
    module Symbols
      class Iota < Symbol
        INPUT = {
          unicodemath: [["iota", "&#x3b9;"], parsing_wrapper(["upiota"], lang: :unicode)],
          asciimath: [["iota", "&#x3b9;"], parsing_wrapper(["upiota"], lang: :asciimath)],
          mathml: ["&#x3b9;"],
          latex: [["upiota", "iota", "&#x3b9;"]],
          omml: ["&#x3b9;"],
          html: ["&#x3b9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upiota"
        end

        def to_asciimath(**)
          "iota"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3b9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3b9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3b9;"
        end

        def to_html(**)
          "&#x3b9;"
        end
      end
    end
  end
end
