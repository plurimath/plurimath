module Plurimath
  module Math
    module Symbols
      class Veemidvert < Symbol
        INPUT = {
          unicodemath: [["&#x2a5b;"], parsing_wrapper(["veemidvert"], lang: :unicode)],
          asciimath: [["&#x2a5b;"], parsing_wrapper(["veemidvert"], lang: :asciimath)],
          mathml: ["&#x2a5b;"],
          latex: [["veemidvert", "&#x2a5b;"]],
          omml: ["&#x2a5b;"],
          html: ["&#x2a5b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\veemidvert"
        end

        def to_asciimath(**)
          parsing_wrapper("veemidvert", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a5b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a5b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a5b;"
        end

        def to_html(**)
          "&#x2a5b;"
        end
      end
    end
  end
end
