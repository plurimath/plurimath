module Plurimath
  module Math
    module Symbols
      class Topsemicircle < Symbol
        INPUT = {
          unicodemath: [["&#x25e0;"], parsing_wrapper(["topsemicircle"], lang: :unicode)],
          asciimath: [["&#x25e0;"], parsing_wrapper(["topsemicircle"], lang: :asciimath)],
          mathml: ["&#x25e0;"],
          latex: [["topsemicircle", "&#x25e0;"]],
          omml: ["&#x25e0;"],
          html: ["&#x25e0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\topsemicircle"
        end

        def to_asciimath(**)
          parsing_wrapper("topsemicircle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25e0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25e0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25e0;"
        end

        def to_html(**)
          "&#x25e0;"
        end
      end
    end
  end
end
