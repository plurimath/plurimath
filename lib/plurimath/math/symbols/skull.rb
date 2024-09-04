module Plurimath
  module Math
    module Symbols
      class Skull < Symbol
        INPUT = {
          unicodemath: [["&#x2620;"], parsing_wrapper(["skull"], lang: :unicode)],
          asciimath: [["&#x2620;"], parsing_wrapper(["skull"], lang: :asciimath)],
          mathml: ["&#x2620;"],
          latex: [["skull", "&#x2620;"]],
          omml: ["&#x2620;"],
          html: ["&#x2620;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\skull"
        end

        def to_asciimath(**)
          parsing_wrapper("skull", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2620;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2620;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2620;"
        end

        def to_html(**)
          "&#x2620;"
        end
      end
    end
  end
end
