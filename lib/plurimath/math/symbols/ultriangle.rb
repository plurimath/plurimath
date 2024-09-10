module Plurimath
  module Math
    module Symbols
      class Ultriangle < Symbol
        INPUT = {
          unicodemath: [["&#x25f8;"], parsing_wrapper(["ultriangle"], lang: :unicode)],
          asciimath: [["&#x25f8;"], parsing_wrapper(["ultriangle"], lang: :asciimath)],
          mathml: ["&#x25f8;"],
          latex: [["ultriangle", "&#x25f8;"]],
          omml: ["&#x25f8;"],
          html: ["&#x25f8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ultriangle"
        end

        def to_asciimath(**)
          parsing_wrapper("ultriangle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25f8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25f8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25f8;"
        end

        def to_html(**)
          "&#x25f8;"
        end
      end
    end
  end
end
