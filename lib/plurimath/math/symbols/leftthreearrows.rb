module Plurimath
  module Math
    module Symbols
      class Leftthreearrows < Symbol
        INPUT = {
          unicodemath: [["&#x2b31;"], parsing_wrapper(["leftthreearrows"], lang: :unicode)],
          asciimath: [["&#x2b31;"], parsing_wrapper(["leftthreearrows"], lang: :asciimath)],
          mathml: ["&#x2b31;"],
          latex: [["leftthreearrows", "&#x2b31;"]],
          omml: ["&#x2b31;"],
          html: ["&#x2b31;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftthreearrows"
        end

        def to_asciimath(**)
          parsing_wrapper("leftthreearrows", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b31;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b31;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b31;"
        end

        def to_html(**)
          "&#x2b31;"
        end
      end
    end
  end
end
