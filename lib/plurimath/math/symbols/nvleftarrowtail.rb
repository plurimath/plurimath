module Plurimath
  module Math
    module Symbols
      class Nvleftarrowtail < Symbol
        INPUT = {
          unicodemath: [["&#x2b3a;"], parsing_wrapper(["nVleftarrowtail"], lang: :unicode)],
          asciimath: [["&#x2b3a;"], parsing_wrapper(["nVleftarrowtail"], lang: :asciimath)],
          mathml: ["&#x2b3a;"],
          latex: [["nVleftarrowtail", "&#x2b3a;"]],
          omml: ["&#x2b3a;"],
          html: ["&#x2b3a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nVleftarrowtail"
        end

        def to_asciimath(**)
          parsing_wrapper("nVleftarrowtail", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b3a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b3a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b3a;"
        end

        def to_html(**)
          "&#x2b3a;"
        end
      end
    end
  end
end
