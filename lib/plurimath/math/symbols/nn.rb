module Plurimath
  module Math
    module Symbols
      class Nn < Symbol
        INPUT = {
          unicodemath: [["&#x2115;"], parsing_wrapper(["NN"], lang: :unicode)],
          asciimath: [["&#x2115;"], parsing_wrapper(["NN"], lang: :asciimath)],
          mathml: ["&#x2115;"],
          latex: [["NN", "&#x2115;"]],
          omml: ["&#x2115;"],
          html: ["&#x2115;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\NN"
        end

        def to_asciimath(**)
          parsing_wrapper("NN", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2115;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2115;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2115;"
        end

        def to_html(**)
          "&#x2115;"
        end
      end
    end
  end
end
