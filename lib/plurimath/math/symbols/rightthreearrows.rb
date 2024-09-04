module Plurimath
  module Math
    module Symbols
      class Rightthreearrows < Symbol
        INPUT = {
          unicodemath: [["&#x21f6;"], parsing_wrapper(["rightthreearrows"], lang: :unicode)],
          asciimath: [["&#x21f6;"], parsing_wrapper(["rightthreearrows"], lang: :asciimath)],
          mathml: ["&#x21f6;"],
          latex: [["rightthreearrows", "&#x21f6;"]],
          omml: ["&#x21f6;"],
          html: ["&#x21f6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightthreearrows"
        end

        def to_asciimath(**)
          parsing_wrapper("rightthreearrows", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21f6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21f6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21f6;"
        end

        def to_html(**)
          "&#x21f6;"
        end
      end
    end
  end
end
