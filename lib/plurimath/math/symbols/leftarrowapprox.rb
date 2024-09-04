module Plurimath
  module Math
    module Symbols
      class Leftarrowapprox < Symbol
        INPUT = {
          unicodemath: [["&#x2b4a;"], parsing_wrapper(["leftarrowapprox"], lang: :unicode)],
          asciimath: [["&#x2b4a;"], parsing_wrapper(["leftarrowapprox"], lang: :asciimath)],
          mathml: ["&#x2b4a;"],
          latex: [["leftarrowapprox", "&#x2b4a;"]],
          omml: ["&#x2b4a;"],
          html: ["&#x2b4a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftarrowapprox"
        end

        def to_asciimath(**)
          parsing_wrapper("leftarrowapprox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b4a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b4a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b4a;"
        end

        def to_html(**)
          "&#x2b4a;"
        end
      end
    end
  end
end
