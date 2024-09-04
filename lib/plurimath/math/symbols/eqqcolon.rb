module Plurimath
  module Math
    module Symbols
      class Eqqcolon < Symbol
        INPUT = {
          unicodemath: [["&#x2255;"], parsing_wrapper(["eqqcolon"], lang: :unicode)],
          asciimath: [["&#x2255;"], parsing_wrapper(["eqqcolon"], lang: :asciimath)],
          mathml: ["&#x2255;"],
          latex: [["eqqcolon", "&#x2255;"]],
          omml: ["&#x2255;"],
          html: ["&#x2255;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\eqqcolon"
        end

        def to_asciimath(**)
          parsing_wrapper("eqqcolon", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2255;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2255;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2255;"
        end

        def to_html(**)
          "&#x2255;"
        end
      end
    end
  end
end
