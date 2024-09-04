module Plurimath
  module Math
    module Symbols
      class Phi < Symbol
        INPUT = {
          unicodemath: [["varphi", "&#x3c6;"], parsing_wrapper(["upvarphi"], lang: :unicode)],
          asciimath: [["varphi", "&#x3c6;"], parsing_wrapper(["upvarphi"], lang: :asciimath)],
          mathml: ["&#x3c6;"],
          latex: [["upvarphi", "varphi", "&#x3c6;"]],
          omml: ["&#x3c6;"],
          html: ["&#x3c6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\phi"
        end

        def to_asciimath(**)
          "phi"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3c6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3c6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3c6;"
        end

        def to_html(**)
          "&#x3c6;"
        end
      end
    end
  end
end
