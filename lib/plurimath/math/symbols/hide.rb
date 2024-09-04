module Plurimath
  module Math
    module Symbols
      class Hide < Symbol
        INPUT = {
          unicodemath: [["&#x29f9;"], parsing_wrapper(["zhide", "xbsol", "hide"], lang: :unicode)],
          asciimath: [["&#x29f9;"], parsing_wrapper(["zhide", "xbsol", "hide"], lang: :asciimath)],
          mathml: ["&#x29f9;"],
          latex: [["zhide", "xbsol", "hide", "&#x29f9;"]],
          omml: ["&#x29f9;"],
          html: ["&#x29f9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\zhide"
        end

        def to_asciimath(**)
          parsing_wrapper("hide", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29f9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29f9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29f9;"
        end

        def to_html(**)
          "&#x29f9;"
        end
      end
    end
  end
end
