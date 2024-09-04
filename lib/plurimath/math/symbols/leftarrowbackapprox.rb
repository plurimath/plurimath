module Plurimath
  module Math
    module Symbols
      class Leftarrowbackapprox < Symbol
        INPUT = {
          unicodemath: [["&#x2b42;"], parsing_wrapper(["leftarrowbackapprox"], lang: :unicode)],
          asciimath: [["&#x2b42;"], parsing_wrapper(["leftarrowbackapprox"], lang: :asciimath)],
          mathml: ["&#x2b42;"],
          latex: [["leftarrowbackapprox", "&#x2b42;"]],
          omml: ["&#x2b42;"],
          html: ["&#x2b42;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftarrowbackapprox"
        end

        def to_asciimath(**)
          parsing_wrapper("leftarrowbackapprox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b42;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b42;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b42;"
        end

        def to_html(**)
          "&#x2b42;"
        end
      end
    end
  end
end
