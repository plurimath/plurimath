module Plurimath
  module Math
    module Symbols
      class To < Symbol
        INPUT = {
          unicodemath: [["rightarrow", "to", "&#x2192;"], parsing_wrapper(["rarr", "->"], lang: :unicode)],
          asciimath: [["rightarrow", "rarr", "->", "to", "&#x2192;"]],
          mathml: ["&#x2192;"],
          latex: [["rightarrow", "to", "&#x2192;"], parsing_wrapper(["rarr", "->"], lang: :latex)],
          omml: ["&#x2192;"],
          html: ["&#x2192;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightarrow"
        end

        def to_asciimath(**)
          "to"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2192;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2192;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2192;"
        end

        def to_html(**)
          "&#x2192;"
        end
      end
    end
  end
end
