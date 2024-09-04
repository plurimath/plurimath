module Plurimath
  module Math
    module Symbols
      class Intcup < Symbol
        INPUT = {
          unicodemath: [["&#x2a1a;"], parsing_wrapper(["intcup"], lang: :unicode)],
          asciimath: [["&#x2a1a;"], parsing_wrapper(["intcup"], lang: :asciimath)],
          mathml: ["&#x2a1a;"],
          latex: [["intcup", "&#x2a1a;"]],
          omml: ["&#x2a1a;"],
          html: ["&#x2a1a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\intcup"
        end

        def to_asciimath(**)
          parsing_wrapper("intcup", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a1a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a1a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a1a;"
        end

        def to_html(**)
          "&#x2a1a;"
        end
      end
    end
  end
end
