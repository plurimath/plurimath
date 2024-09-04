module Plurimath
  module Math
    module Symbols
      class Tcohm < Symbol
        INPUT = {
          unicodemath: [["&#x2126;"], parsing_wrapper(["tcohm"], lang: :unicode)],
          asciimath: [["&#x2126;"], parsing_wrapper(["tcohm"], lang: :asciimath)],
          mathml: ["&#x2126;"],
          latex: [["tcohm", "&#x2126;"]],
          omml: ["&#x2126;"],
          html: ["&#x2126;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\tcohm"
        end

        def to_asciimath(**)
          parsing_wrapper("tcohm", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2126;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2126;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2126;"
        end

        def to_html(**)
          "&#x2126;"
        end
      end
    end
  end
end
