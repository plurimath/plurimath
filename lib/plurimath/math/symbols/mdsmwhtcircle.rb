module Plurimath
  module Math
    module Symbols
      class Mdsmwhtcircle < Symbol
        INPUT = {
          unicodemath: [["&#x26ac;"], parsing_wrapper(["mdsmwhtcircle"], lang: :unicode)],
          asciimath: [["&#x26ac;"], parsing_wrapper(["mdsmwhtcircle"], lang: :asciimath)],
          mathml: ["&#x26ac;"],
          latex: [["mdsmwhtcircle", "&#x26ac;"]],
          omml: ["&#x26ac;"],
          html: ["&#x26ac;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mdsmwhtcircle"
        end

        def to_asciimath(**)
          parsing_wrapper("mdsmwhtcircle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x26ac;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x26ac;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x26ac;"
        end

        def to_html(**)
          "&#x26ac;"
        end
      end
    end
  end
end
