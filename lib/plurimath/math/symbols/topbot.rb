module Plurimath
  module Math
    module Symbols
      class Topbot < Symbol
        INPUT = {
          unicodemath: [["&#x2336;"], parsing_wrapper(["topbot"], lang: :unicode)],
          asciimath: [["&#x2336;"], parsing_wrapper(["topbot"], lang: :asciimath)],
          mathml: ["&#x2336;"],
          latex: [["topbot", "&#x2336;"]],
          omml: ["&#x2336;"],
          html: ["&#x2336;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\topbot"
        end

        def to_asciimath(**)
          parsing_wrapper("topbot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2336;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2336;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2336;"
        end

        def to_html(**)
          "&#x2336;"
        end
      end
    end
  end
end
