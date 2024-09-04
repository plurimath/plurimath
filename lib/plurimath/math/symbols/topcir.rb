module Plurimath
  module Math
    module Symbols
      class Topcir < Symbol
        INPUT = {
          unicodemath: [["&#x2af1;"], parsing_wrapper(["topcir"], lang: :unicode)],
          asciimath: [["&#x2af1;"], parsing_wrapper(["topcir"], lang: :asciimath)],
          mathml: ["&#x2af1;"],
          latex: [["topcir", "&#x2af1;"]],
          omml: ["&#x2af1;"],
          html: ["&#x2af1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\topcir"
        end

        def to_asciimath(**)
          parsing_wrapper("topcir", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2af1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2af1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2af1;"
        end

        def to_html(**)
          "&#x2af1;"
        end
      end
    end
  end
end
