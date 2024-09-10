module Plurimath
  module Math
    module Symbols
      class Triangleplus < Symbol
        INPUT = {
          unicodemath: [["&#x2a39;"], parsing_wrapper(["triangleplus"], lang: :unicode)],
          asciimath: [["&#x2a39;"], parsing_wrapper(["triangleplus"], lang: :asciimath)],
          mathml: ["&#x2a39;"],
          latex: [["triangleplus", "&#x2a39;"]],
          omml: ["&#x2a39;"],
          html: ["&#x2a39;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\triangleplus"
        end

        def to_asciimath(**)
          parsing_wrapper("triangleplus", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a39;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a39;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a39;"
        end

        def to_html(**)
          "&#x2a39;"
        end
      end
    end
  end
end
