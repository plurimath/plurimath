module Plurimath
  module Math
    module Symbols
      class Cwcirclearrow < Symbol
        INPUT = {
          unicodemath: [["&#x2941;"], parsing_wrapper(["cwcirclearrow"], lang: :unicode)],
          asciimath: [["&#x2941;"], parsing_wrapper(["cwcirclearrow"], lang: :asciimath)],
          mathml: ["&#x2941;"],
          latex: [["cwcirclearrow", "&#x2941;"]],
          omml: ["&#x2941;"],
          html: ["&#x2941;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\cwcirclearrow"
        end

        def to_asciimath(**)
          parsing_wrapper("cwcirclearrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2941;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2941;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2941;"
        end

        def to_html(**)
          "&#x2941;"
        end
      end
    end
  end
end
