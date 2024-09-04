module Plurimath
  module Math
    module Symbols
      class Rightupvectorbar < Symbol
        INPUT = {
          unicodemath: [["&#x2954;"], parsing_wrapper(["barupharpoonright", "RightUpVectorBar"], lang: :unicode)],
          asciimath: [["&#x2954;"], parsing_wrapper(["barupharpoonright", "RightUpVectorBar"], lang: :asciimath)],
          mathml: ["&#x2954;"],
          latex: [["barupharpoonright", "RightUpVectorBar", "&#x2954;"]],
          omml: ["&#x2954;"],
          html: ["&#x2954;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\barupharpoonright"
        end

        def to_asciimath(**)
          parsing_wrapper("RightUpVectorBar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2954;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2954;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2954;"
        end

        def to_html(**)
          "&#x2954;"
        end
      end
    end
  end
end
