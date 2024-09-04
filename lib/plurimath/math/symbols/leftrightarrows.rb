module Plurimath
  module Math
    module Symbols
      class Leftrightarrows < Symbol
        INPUT = {
          unicodemath: [["leftrightarrows", "&#x21c6;"]],
          asciimath: [["&#x21c6;"], parsing_wrapper(["leftrightarrows"], lang: :asciimath)],
          mathml: ["&#x21c6;"],
          latex: [["leftrightarrows", "&#x21c6;"]],
          omml: ["&#x21c6;"],
          html: ["&#x21c6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftrightarrows"
        end

        def to_asciimath(**)
          parsing_wrapper("leftrightarrows", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21c6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21c6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21c6;"
        end

        def to_html(**)
          "&#x21c6;"
        end
      end
    end
  end
end
