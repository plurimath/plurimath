module Plurimath
  module Math
    module Symbols
      class Rgroup < Symbol
        INPUT = {
          unicodemath: [["&#x27ef;"], parsing_wrapper(["rgroup"], lang: :unicode)],
          asciimath: [["&#x27ef;"], parsing_wrapper(["rgroup"], lang: :asciimath)],
          mathml: ["&#x27ef;"],
          latex: [["rgroup", "&#x27ef;"]],
          omml: ["&#x27ef;"],
          html: ["&#x27ef;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rgroup"
        end

        def to_asciimath(**)
          parsing_wrapper("rgroup", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27ef;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27ef;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27ef;"
        end

        def to_html(**)
          "&#x27ef;"
        end
      end
    end
  end
end
