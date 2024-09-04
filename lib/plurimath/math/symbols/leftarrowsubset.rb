module Plurimath
  module Math
    module Symbols
      class Leftarrowsubset < Symbol
        INPUT = {
          unicodemath: [["&#x297a;"], parsing_wrapper(["leftarrowsubset"], lang: :unicode)],
          asciimath: [["&#x297a;"], parsing_wrapper(["leftarrowsubset"], lang: :asciimath)],
          mathml: ["&#x297a;"],
          latex: [["leftarrowsubset", "&#x297a;"]],
          omml: ["&#x297a;"],
          html: ["&#x297a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftarrowsubset"
        end

        def to_asciimath(**)
          parsing_wrapper("leftarrowsubset", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x297a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x297a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x297a;"
        end

        def to_html(**)
          "&#x297a;"
        end
      end
    end
  end
end
