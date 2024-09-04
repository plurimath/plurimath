module Plurimath
  module Math
    module Symbols
      class Lbrackubar < Symbol
        INPUT = {
          unicodemath: [["&#x298b;"], parsing_wrapper(["lbrackubar"], lang: :unicode)],
          asciimath: [["&#x298b;"], parsing_wrapper(["lbrackubar"], lang: :asciimath)],
          mathml: ["&#x298b;"],
          latex: [["lbrackubar", "&#x298b;"]],
          omml: ["&#x298b;"],
          html: ["&#x298b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lbrackubar"
        end

        def to_asciimath(**)
          parsing_wrapper("lbrackubar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x298b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x298b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x298b;"
        end

        def to_html(**)
          "&#x298b;"
        end
      end
    end
  end
end
