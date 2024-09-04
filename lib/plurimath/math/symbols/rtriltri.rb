module Plurimath
  module Math
    module Symbols
      class Rtriltri < Symbol
        INPUT = {
          unicodemath: [["&#x29ce;"], parsing_wrapper(["rtriltri"], lang: :unicode)],
          asciimath: [["&#x29ce;"], parsing_wrapper(["rtriltri"], lang: :asciimath)],
          mathml: ["&#x29ce;"],
          latex: [["rtriltri", "&#x29ce;"]],
          omml: ["&#x29ce;"],
          html: ["&#x29ce;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rtriltri"
        end

        def to_asciimath(**)
          parsing_wrapper("rtriltri", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29ce;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29ce;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29ce;"
        end

        def to_html(**)
          "&#x29ce;"
        end
      end
    end
  end
end
