module Plurimath
  module Math
    module Symbols
      class Fallingdotseq < Symbol
        INPUT = {
          unicodemath: [["fallingdotseq", "&#x2252;"]],
          asciimath: [["&#x2252;"], parsing_wrapper(["fallingdotseq"], lang: :asciimath)],
          mathml: ["&#x2252;"],
          latex: [["fallingdotseq", "&#x2252;"]],
          omml: ["&#x2252;"],
          html: ["&#x2252;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\fallingdotseq"
        end

        def to_asciimath(**)
          parsing_wrapper("fallingdotseq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2252;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2252;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2252;"
        end

        def to_html(**)
          "&#x2252;"
        end
      end
    end
  end
end
