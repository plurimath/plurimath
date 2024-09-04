module Plurimath
  module Math
    module Symbols
      class Ee < Symbol
        INPUT = {
          unicodemath: [["exists", "&#x2203;"], parsing_wrapper(["EE", "exi"], lang: :unicode)],
          asciimath: [["exists", "EE", "&#x2203;"], parsing_wrapper(["exi"], lang: :asciimath)],
          mathml: ["&#x2203;"],
          latex: [["exists", "exi", "&#x2203;"], parsing_wrapper(["EE"], lang: :latex)],
          omml: ["&#x2203;"],
          html: ["&#x2203;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\exists"
        end

        def to_asciimath(**)
          "exists"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2203;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2203;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2203;"
        end

        def to_html(**)
          "&#x2203;"
        end
      end
    end
  end
end
