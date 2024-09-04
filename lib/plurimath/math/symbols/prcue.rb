module Plurimath
  module Math
    module Symbols
      class Prcue < Symbol
        INPUT = {
          unicodemath: [["prcue", "preccurlyeq", "&#x227c;"], parsing_wrapper(["PrecedesSlantEqual"], lang: :unicode)],
          asciimath: [["&#x227c;"], parsing_wrapper(["prcue", "preccurlyeq", "PrecedesSlantEqual"], lang: :asciimath)],
          mathml: ["&#x227c;"],
          latex: [["PrecedesSlantEqual", "preccurlyeq", "&#x227c;"], parsing_wrapper(["prcue"], lang: :latex)],
          omml: ["&#x227c;"],
          html: ["&#x227c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\PrecedesSlantEqual"
        end

        def to_asciimath(**)
          parsing_wrapper("prcue", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x227c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x227c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x227c;"
        end

        def to_html(**)
          "&#x227c;"
        end
      end
    end
  end
end
