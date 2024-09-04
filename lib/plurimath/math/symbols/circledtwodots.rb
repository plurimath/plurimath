module Plurimath
  module Math
    module Symbols
      class Circledtwodots < Symbol
        INPUT = {
          unicodemath: [["&#x2687;"], parsing_wrapper(["circledtwodots"], lang: :unicode)],
          asciimath: [["&#x2687;"], parsing_wrapper(["circledtwodots"], lang: :asciimath)],
          mathml: ["&#x2687;"],
          latex: [["circledtwodots", "&#x2687;"]],
          omml: ["&#x2687;"],
          html: ["&#x2687;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circledtwodots"
        end

        def to_asciimath(**)
          parsing_wrapper("circledtwodots", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2687;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2687;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2687;"
        end

        def to_html(**)
          "&#x2687;"
        end
      end
    end
  end
end
