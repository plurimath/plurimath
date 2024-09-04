module Plurimath
  module Math
    module Symbols
      class Dottimes < Symbol
        INPUT = {
          unicodemath: [["&#x2a30;"], parsing_wrapper(["dottimes"], lang: :unicode)],
          asciimath: [["&#x2a30;"], parsing_wrapper(["dottimes"], lang: :asciimath)],
          mathml: ["&#x2a30;"],
          latex: [["dottimes", "&#x2a30;"]],
          omml: ["&#x2a30;"],
          html: ["&#x2a30;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\dottimes"
        end

        def to_asciimath(**)
          parsing_wrapper("dottimes", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a30;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a30;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a30;"
        end

        def to_html(**)
          "&#x2a30;"
        end
      end
    end
  end
end
