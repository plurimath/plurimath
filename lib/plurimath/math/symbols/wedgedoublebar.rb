module Plurimath
  module Math
    module Symbols
      class Wedgedoublebar < Symbol
        INPUT = {
          unicodemath: [["&#x2a60;"], parsing_wrapper(["wedgedoublebar"], lang: :unicode)],
          asciimath: [["&#x2a60;"], parsing_wrapper(["wedgedoublebar"], lang: :asciimath)],
          mathml: ["&#x2a60;"],
          latex: [["wedgedoublebar", "&#x2a60;"]],
          omml: ["&#x2a60;"],
          html: ["&#x2a60;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\wedgedoublebar"
        end

        def to_asciimath(**)
          parsing_wrapper("wedgedoublebar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a60;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a60;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a60;"
        end

        def to_html(**)
          "&#x2a60;"
        end
      end
    end
  end
end
