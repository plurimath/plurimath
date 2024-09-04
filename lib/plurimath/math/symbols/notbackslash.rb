module Plurimath
  module Math
    module Symbols
      class Notbackslash < Symbol
        INPUT = {
          unicodemath: [["&#x2340;"], parsing_wrapper(["APLnotbackslash", "notbackslash"], lang: :unicode)],
          asciimath: [["&#x2340;"], parsing_wrapper(["APLnotbackslash", "notbackslash"], lang: :asciimath)],
          mathml: ["&#x2340;"],
          latex: [["APLnotbackslash", "notbackslash", "&#x2340;"]],
          omml: ["&#x2340;"],
          html: ["&#x2340;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\APLnotbackslash"
        end

        def to_asciimath(**)
          parsing_wrapper("notbackslash", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2340;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2340;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2340;"
        end

        def to_html(**)
          "&#x2340;"
        end
      end
    end
  end
end
