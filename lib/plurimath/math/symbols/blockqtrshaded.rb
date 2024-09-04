module Plurimath
  module Math
    module Symbols
      class Blockqtrshaded < Symbol
        INPUT = {
          unicodemath: [["&#x2591;"], parsing_wrapper(["blockqtrshaded"], lang: :unicode)],
          asciimath: [["&#x2591;"], parsing_wrapper(["blockqtrshaded"], lang: :asciimath)],
          mathml: ["&#x2591;"],
          latex: [["blockqtrshaded", "&#x2591;"]],
          omml: ["&#x2591;"],
          html: ["&#x2591;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blockqtrshaded"
        end

        def to_asciimath(**)
          parsing_wrapper("blockqtrshaded", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2591;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2591;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2591;"
        end

        def to_html(**)
          "&#x2591;"
        end
      end
    end
  end
end
