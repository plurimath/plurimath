module Plurimath
  module Math
    module Symbols
      class Qq < Symbol
        INPUT = {
          unicodemath: [["&#x211a;"], parsing_wrapper(["QQ"], lang: :unicode)],
          asciimath: [["&#x211a;"], parsing_wrapper(["QQ"], lang: :asciimath)],
          mathml: ["&#x211a;"],
          latex: [["QQ", "&#x211a;"]],
          omml: ["&#x211a;"],
          html: ["&#x211a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\QQ"
        end

        def to_asciimath(**)
          parsing_wrapper("QQ", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x211a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x211a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x211a;"
        end

        def to_html(**)
          "&#x211a;"
        end
      end
    end
  end
end
