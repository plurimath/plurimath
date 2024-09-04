module Plurimath
  module Math
    module Symbols
      class Simrdots < Symbol
        INPUT = {
          unicodemath: [["&#x2a6b;"], parsing_wrapper(["simrdots"], lang: :unicode)],
          asciimath: [["&#x2a6b;"], parsing_wrapper(["simrdots"], lang: :asciimath)],
          mathml: ["&#x2a6b;"],
          latex: [["simrdots", "&#x2a6b;"]],
          omml: ["&#x2a6b;"],
          html: ["&#x2a6b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\simrdots"
        end

        def to_asciimath(**)
          parsing_wrapper("simrdots", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a6b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a6b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a6b;"
        end

        def to_html(**)
          "&#x2a6b;"
        end
      end
    end
  end
end
