module Plurimath
  module Math
    module Symbols
      class Isinobar < Symbol
        INPUT = {
          unicodemath: [["&#x22f7;"], parsing_wrapper(["isinobar"], lang: :unicode)],
          asciimath: [["&#x22f7;"], parsing_wrapper(["isinobar"], lang: :asciimath)],
          mathml: ["&#x22f7;"],
          latex: [["isinobar", "&#x22f7;"]],
          omml: ["&#x22f7;"],
          html: ["&#x22f7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\isinobar"
        end

        def to_asciimath(**)
          parsing_wrapper("isinobar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22f7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22f7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22f7;"
        end

        def to_html(**)
          "&#x22f7;"
        end
      end
    end
  end
end
