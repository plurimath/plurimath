module Plurimath
  module Math
    module Symbols
      class Blockthreeqtrshaded < Symbol
        INPUT = {
          unicodemath: [["&#x2593;"], parsing_wrapper(["blockthreeqtrshaded"], lang: :unicode)],
          asciimath: [["&#x2593;"], parsing_wrapper(["blockthreeqtrshaded"], lang: :asciimath)],
          mathml: ["&#x2593;"],
          latex: [["blockthreeqtrshaded", "&#x2593;"]],
          omml: ["&#x2593;"],
          html: ["&#x2593;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blockthreeqtrshaded"
        end

        def to_asciimath(**)
          parsing_wrapper("blockthreeqtrshaded", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2593;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2593;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2593;"
        end

        def to_html(**)
          "&#x2593;"
        end
      end
    end
  end
end
