module Plurimath
  module Math
    module Symbols
      class Bagmember < Symbol
        INPUT = {
          unicodemath: [["&#x22ff;"], parsing_wrapper(["bagmember"], lang: :unicode)],
          asciimath: [["&#x22ff;"], parsing_wrapper(["bagmember"], lang: :asciimath)],
          mathml: ["&#x22ff;"],
          latex: [["bagmember", "&#x22ff;"]],
          omml: ["&#x22ff;"],
          html: ["&#x22ff;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bagmember"
        end

        def to_asciimath(**)
          parsing_wrapper("bagmember", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22ff;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22ff;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22ff;"
        end

        def to_html(**)
          "&#x22ff;"
        end
      end
    end
  end
end
