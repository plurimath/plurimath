module Plurimath
  module Math
    module Symbols
      class Leftdbkarrow < Symbol
        INPUT = {
          unicodemath: [["&#x290e;"], parsing_wrapper(["leftdbkarrow"], lang: :unicode)],
          asciimath: [["&#x290e;"], parsing_wrapper(["leftdbkarrow"], lang: :asciimath)],
          mathml: ["&#x290e;"],
          latex: [["leftdbkarrow", "&#x290e;"]],
          omml: ["&#x290e;"],
          html: ["&#x290e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftdbkarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("leftdbkarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x290e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x290e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x290e;"
        end

        def to_html(**)
          "&#x290e;"
        end
      end
    end
  end
end
