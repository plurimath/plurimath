module Plurimath
  module Math
    module Symbols
      class Operp < Symbol
        INPUT = {
          unicodemath: [["&#x29b9;"], parsing_wrapper(["operp"], lang: :unicode)],
          asciimath: [["&#x29b9;"], parsing_wrapper(["operp"], lang: :asciimath)],
          mathml: ["&#x29b9;"],
          latex: [["operp", "&#x29b9;"]],
          omml: ["&#x29b9;"],
          html: ["&#x29b9;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\operp"
        end

        def to_asciimath(**)
          parsing_wrapper("operp", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29b9;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29b9;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29b9;"
        end

        def to_html(**)
          "&#x29b9;"
        end
      end
    end
  end
end
