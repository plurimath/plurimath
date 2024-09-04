module Plurimath
  module Math
    module Symbols
      class Nnn < Symbol
        INPUT = {
          unicodemath: [["&#x22c2;"], parsing_wrapper(["bigcap", "nnn", "dint"], lang: :unicode)],
          asciimath: [["bigcap", "nnn", "&#x22c2;"], parsing_wrapper(["dint"], lang: :asciimath)],
          mathml: ["&#x22c2;"],
          latex: [["bigcap", "dint", "&#x22c2;"], parsing_wrapper(["nnn"], lang: :latex)],
          omml: ["&#x22c2;"],
          html: ["&#x22c2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigcap"
        end

        def to_asciimath(**)
          "bigcap"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22c2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22c2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22c2;"
        end

        def to_html(**)
          "&#x22c2;"
        end
      end
    end
  end
end
