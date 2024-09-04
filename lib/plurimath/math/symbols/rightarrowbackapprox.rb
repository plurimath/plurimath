module Plurimath
  module Math
    module Symbols
      class Rightarrowbackapprox < Symbol
        INPUT = {
          unicodemath: [["&#x2b48;"], parsing_wrapper(["rightarrowbackapprox"], lang: :unicode)],
          asciimath: [["&#x2b48;"], parsing_wrapper(["rightarrowbackapprox"], lang: :asciimath)],
          mathml: ["&#x2b48;"],
          latex: [["rightarrowbackapprox", "&#x2b48;"]],
          omml: ["&#x2b48;"],
          html: ["&#x2b48;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightarrowbackapprox"
        end

        def to_asciimath(**)
          parsing_wrapper("rightarrowbackapprox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b48;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b48;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b48;"
        end

        def to_html(**)
          "&#x2b48;"
        end
      end
    end
  end
end
