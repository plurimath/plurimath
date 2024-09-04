module Plurimath
  module Math
    module Symbols
      class Uparrowoncircle < Symbol
        INPUT = {
          unicodemath: [["&#x29bd;"], parsing_wrapper(["uparrowoncircle"], lang: :unicode)],
          asciimath: [["&#x29bd;"], parsing_wrapper(["uparrowoncircle"], lang: :asciimath)],
          mathml: ["&#x29bd;"],
          latex: [["uparrowoncircle", "&#x29bd;"]],
          omml: ["&#x29bd;"],
          html: ["&#x29bd;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\uparrowoncircle"
        end

        def to_asciimath(**)
          parsing_wrapper("uparrowoncircle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29bd;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29bd;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29bd;"
        end

        def to_html(**)
          "&#x29bd;"
        end
      end
    end
  end
end
