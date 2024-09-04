module Plurimath
  module Math
    module Symbols
      class Ox < Symbol
        INPUT = {
          unicodemath: [["otimes", "&#x2297;"], parsing_wrapper(["ox"], lang: :unicode)],
          asciimath: [["otimes", "ox", "&#x2297;"]],
          mathml: ["&#x2297;"],
          latex: [["otimes", "&#x2297;"], parsing_wrapper(["ox"], lang: :latex)],
          omml: ["&#x2297;"],
          html: ["&#x2297;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ox"
        end

        def to_asciimath(**)
          "ox"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2297;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2297;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2297;"
        end

        def to_html(**)
          "&#x2297;"
        end
      end
    end
  end
end
