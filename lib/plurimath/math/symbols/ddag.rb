module Plurimath
  module Math
    module Symbols
      class Ddag < Symbol
        INPUT = {
          unicodemath: [["ddag", "&#x2021;"], parsing_wrapper(["ddagger"], lang: :unicode)],
          asciimath: [["&#x2021;"], parsing_wrapper(["ddag", "ddagger"], lang: :asciimath)],
          mathml: ["&#x2021;"],
          latex: [["ddagger", "&#x2021;"], parsing_wrapper(["ddag"], lang: :latex)],
          omml: ["&#x2021;"],
          html: ["&#x2021;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ddagger"
        end

        def to_asciimath(**)
          parsing_wrapper("ddag", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2021;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2021;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2021;"
        end

        def to_html(**)
          "&#x2021;"
        end
      end
    end
  end
end
