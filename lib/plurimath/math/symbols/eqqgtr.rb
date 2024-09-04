module Plurimath
  module Math
    module Symbols
      class Eqqgtr < Symbol
        INPUT = {
          unicodemath: [["&#x2a9a;"], parsing_wrapper(["eqqgtr"], lang: :unicode)],
          asciimath: [["&#x2a9a;"], parsing_wrapper(["eqqgtr"], lang: :asciimath)],
          mathml: ["&#x2a9a;"],
          latex: [["eqqgtr", "&#x2a9a;"]],
          omml: ["&#x2a9a;"],
          html: ["&#x2a9a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\eqqgtr"
        end

        def to_asciimath(**)
          parsing_wrapper("eqqgtr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a9a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a9a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a9a;"
        end

        def to_html(**)
          "&#x2a9a;"
        end
      end
    end
  end
end
