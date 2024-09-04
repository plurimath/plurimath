module Plurimath
  module Math
    module Symbols
      class Invwhiteupperhalfcircle < Symbol
        INPUT = {
          unicodemath: [["&#x25da;"], parsing_wrapper(["invwhiteupperhalfcircle"], lang: :unicode)],
          asciimath: [["&#x25da;"], parsing_wrapper(["invwhiteupperhalfcircle"], lang: :asciimath)],
          mathml: ["&#x25da;"],
          latex: [["invwhiteupperhalfcircle", "&#x25da;"]],
          omml: ["&#x25da;"],
          html: ["&#x25da;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\invwhiteupperhalfcircle"
        end

        def to_asciimath(**)
          parsing_wrapper("invwhiteupperhalfcircle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25da;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25da;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25da;"
        end

        def to_html(**)
          "&#x25da;"
        end
      end
    end
  end
end
