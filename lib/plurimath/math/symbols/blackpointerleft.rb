module Plurimath
  module Math
    module Symbols
      class Blackpointerleft < Symbol
        INPUT = {
          unicodemath: [["&#x25c4;"], parsing_wrapper(["blackpointerleft"], lang: :unicode)],
          asciimath: [["&#x25c4;"], parsing_wrapper(["blackpointerleft"], lang: :asciimath)],
          mathml: ["&#x25c4;"],
          latex: [["blackpointerleft", "&#x25c4;"]],
          omml: ["&#x25c4;"],
          html: ["&#x25c4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blackpointerleft"
        end

        def to_asciimath(**)
          parsing_wrapper("blackpointerleft", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25c4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25c4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25c4;"
        end

        def to_html(**)
          "&#x25c4;"
        end
      end
    end
  end
end
