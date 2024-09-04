module Plurimath
  module Math
    module Symbols
      class Closure < Symbol
        INPUT = {
          unicodemath: [["&#x2050;"], parsing_wrapper(["closure"], lang: :unicode)],
          asciimath: [["&#x2050;"], parsing_wrapper(["closure"], lang: :asciimath)],
          mathml: ["&#x2050;"],
          latex: [["closure", "&#x2050;"]],
          omml: ["&#x2050;"],
          html: ["&#x2050;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\closure"
        end

        def to_asciimath(**)
          parsing_wrapper("closure", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2050;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2050;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2050;"
        end

        def to_html(**)
          "&#x2050;"
        end
      end
    end
  end
end
