module Plurimath
  module Math
    module Symbols
      class Semicolon < Symbol
        INPUT = {
          unicodemath: [["&#x3b;"], parsing_wrapper([";", "semicolon"], lang: :unicode)],
          asciimath: [[";", "&#x3b;"], parsing_wrapper(["semicolon"], lang: :asciimath)],
          mathml: ["&#x3b;"],
          latex: [["semicolon", ";", "&#x3b;"]],
          omml: ["&#x3b;"],
          html: ["&#x3b;"],
        }.freeze

        # output methods
        def to_latex(**)
          ";"
        end

        def to_asciimath(**)
          ";"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x3b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3b;"
        end

        def to_html(**)
          "&#x3b;"
        end
      end
    end
  end
end
