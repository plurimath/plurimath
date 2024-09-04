module Plurimath
  module Math
    module Symbols
      class Upin < Symbol
        INPUT = {
          unicodemath: [["&#x27d2;"], parsing_wrapper(["upin"], lang: :unicode)],
          asciimath: [["&#x27d2;"], parsing_wrapper(["upin"], lang: :asciimath)],
          mathml: ["&#x27d2;"],
          latex: [["upin", "&#x27d2;"]],
          omml: ["&#x27d2;"],
          html: ["&#x27d2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upin"
        end

        def to_asciimath(**)
          parsing_wrapper("upin", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x27d2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x27d2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x27d2;"
        end

        def to_html(**)
          "&#x27d2;"
        end
      end
    end
  end
end
