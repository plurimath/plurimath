module Plurimath
  module Math
    module Symbols
      class Eqqplus < Symbol
        INPUT = {
          unicodemath: [["&#x2a71;"], parsing_wrapper(["eqqplus"], lang: :unicode)],
          asciimath: [["&#x2a71;"], parsing_wrapper(["eqqplus"], lang: :asciimath)],
          mathml: ["&#x2a71;"],
          latex: [["eqqplus", "&#x2a71;"]],
          omml: ["&#x2a71;"],
          html: ["&#x2a71;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\eqqplus"
        end

        def to_asciimath(**)
          parsing_wrapper("eqqplus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a71;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a71;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a71;"
        end

        def to_html(**)
          "&#x2a71;"
        end
      end
    end
  end
end
