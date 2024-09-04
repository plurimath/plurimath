module Plurimath
  module Math
    module Symbols
      class Mathdollar < Symbol
        INPUT = {
          unicodemath: [["&#x24;"], parsing_wrapper(["$", "mathdollar"], lang: :unicode)],
          asciimath: [["$", "&#x24;"], parsing_wrapper(["mathdollar"], lang: :asciimath)],
          mathml: ["&#x24;"],
          latex: [["mathdollar", "$", "&#x24;"]],
          omml: ["&#x24;"],
          html: ["&#x24;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mathdollar"
        end

        def to_asciimath(**)
          "$"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x24;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x24;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x24;"
        end

        def to_html(**)
          "&#x24;"
        end
      end
    end
  end
end
