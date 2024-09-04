module Plurimath
  module Math
    module Symbols
      class Blackcircledtwodots < Symbol
        INPUT = {
          unicodemath: [["&#x2689;"], parsing_wrapper(["blackcircledtwodots"], lang: :unicode)],
          asciimath: [["&#x2689;"], parsing_wrapper(["blackcircledtwodots"], lang: :asciimath)],
          mathml: ["&#x2689;"],
          latex: [["blackcircledtwodots", "&#x2689;"]],
          omml: ["&#x2689;"],
          html: ["&#x2689;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blackcircledtwodots"
        end

        def to_asciimath(**)
          parsing_wrapper("blackcircledtwodots", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2689;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2689;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2689;"
        end

        def to_html(**)
          "&#x2689;"
        end
      end
    end
  end
end
