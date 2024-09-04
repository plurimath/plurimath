module Plurimath
  module Math
    module Symbols
      class Sqint < Symbol
        INPUT = {
          unicodemath: [["&#x2a16;"], parsing_wrapper(["sqrint", "sqint"], lang: :unicode)],
          asciimath: [["&#x2a16;"], parsing_wrapper(["sqrint", "sqint"], lang: :asciimath)],
          mathml: ["&#x2a16;"],
          latex: [["sqrint", "sqint", "&#x2a16;"]],
          omml: ["&#x2a16;"],
          html: ["&#x2a16;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sqrint"
        end

        def to_asciimath(**)
          parsing_wrapper("sqint", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a16;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a16;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a16;"
        end

        def to_html(**)
          "&#x2a16;"
        end
      end
    end
  end
end
