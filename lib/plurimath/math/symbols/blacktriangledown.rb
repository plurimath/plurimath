module Plurimath
  module Math
    module Symbols
      class Blacktriangledown < Symbol
        INPUT = {
          unicodemath: [["&#x25be;"], parsing_wrapper(["blacktriangledown"], lang: :unicode)],
          asciimath: [["&#x25be;"], parsing_wrapper(["blacktriangledown"], lang: :asciimath)],
          mathml: ["&#x25be;"],
          latex: [["blacktriangledown", "&#x25be;"]],
          omml: ["&#x25be;"],
          html: ["&#x25be;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blacktriangledown"
        end

        def to_asciimath(**)
          parsing_wrapper("blacktriangledown", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25be;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25be;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25be;"
        end

        def to_html(**)
          "&#x25be;"
        end
      end
    end
  end
end
