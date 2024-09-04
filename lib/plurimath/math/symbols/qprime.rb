module Plurimath
  module Math
    module Symbols
      class Qprime < Symbol
        INPUT = {
          unicodemath: [["&#x2057;"], parsing_wrapper(["fourth", "qprime"], lang: :unicode)],
          asciimath: [["&#x2057;"], parsing_wrapper(["fourth", "qprime"], lang: :asciimath)],
          mathml: ["&#x2057;"],
          latex: [["fourth", "qprime", "&#x2057;"]],
          omml: ["&#x2057;"],
          html: ["&#x2057;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\qprime"
        end

        def to_asciimath(**)
          "qprime"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2057;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2057;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2057;"
        end

        def to_html(**)
          "&#x2057;"
        end
      end
    end
  end
end
