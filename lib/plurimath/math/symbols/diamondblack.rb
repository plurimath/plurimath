module Plurimath
  module Math
    module Symbols
      class Diamondblack < Symbol
        INPUT = {
          unicodemath: [["&#x25c6;"], parsing_wrapper(["mdlgblkdiamond", "Diamondblack"], lang: :unicode)],
          asciimath: [["&#x25c6;"], parsing_wrapper(["mdlgblkdiamond", "Diamondblack"], lang: :asciimath)],
          mathml: ["&#x25c6;"],
          latex: [["mdlgblkdiamond", "Diamondblack", "&#x25c6;"]],
          omml: ["&#x25c6;"],
          html: ["&#x25c6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mdlgblkdiamond"
        end

        def to_asciimath(**)
          parsing_wrapper("Diamondblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25c6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25c6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25c6;"
        end

        def to_html(**)
          "&#x25c6;"
        end
      end
    end
  end
end
