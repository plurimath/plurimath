module Plurimath
  module Math
    module Symbols
      class Yen < Symbol
        INPUT = {
          unicodemath: [["&#xa5;"], parsing_wrapper(["yen"], lang: :unicode)],
          asciimath: [["&#xa5;"], parsing_wrapper(["yen"], lang: :asciimath)],
          mathml: ["&#xa5;"],
          latex: [["yen", "&#xa5;"]],
          omml: ["&#xa5;"],
          html: ["&#xa5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\yen"
        end

        def to_asciimath(**)
          parsing_wrapper("yen", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#xa5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#xa5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#xa5;"
        end

        def to_html(**)
          "&#xa5;"
        end
      end
    end
  end
end
