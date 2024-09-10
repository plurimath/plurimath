module Plurimath
  module Math
    module Symbols
      class Twoheaduparrowcircle < Symbol
        INPUT = {
          unicodemath: [["&#x2949;"], parsing_wrapper(["twoheaduparrowcircle"], lang: :unicode)],
          asciimath: [["&#x2949;"], parsing_wrapper(["twoheaduparrowcircle"], lang: :asciimath)],
          mathml: ["&#x2949;"],
          latex: [["twoheaduparrowcircle", "&#x2949;"]],
          omml: ["&#x2949;"],
          html: ["&#x2949;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\twoheaduparrowcircle"
        end

        def to_asciimath(**)
          parsing_wrapper("twoheaduparrowcircle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2949;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2949;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2949;"
        end

        def to_html(**)
          "&#x2949;"
        end
      end
    end
  end
end
