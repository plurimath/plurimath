module Plurimath
  module Math
    module Symbols
      class Leftcircle < Symbol
        INPUT = {
          unicodemath: [["&#x25d6;"], parsing_wrapper(["blacklefthalfcircle", "LEFTCIRCLE"], lang: :unicode)],
          asciimath: [["&#x25d6;"], parsing_wrapper(["blacklefthalfcircle", "LEFTCIRCLE"], lang: :asciimath)],
          mathml: ["&#x25d6;"],
          latex: [["blacklefthalfcircle", "LEFTCIRCLE", "&#x25d6;"]],
          omml: ["&#x25d6;"],
          html: ["&#x25d6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blacklefthalfcircle"
        end

        def to_asciimath(**)
          parsing_wrapper("LEFTCIRCLE", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25d6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25d6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25d6;"
        end

        def to_html(**)
          "&#x25d6;"
        end
      end
    end
  end
end
