module Plurimath
  module Math
    module Symbols
      class Llarc < Symbol
        INPUT = {
          unicodemath: [["&#x25df;"], parsing_wrapper(["llarc"], lang: :unicode)],
          asciimath: [["&#x25df;"], parsing_wrapper(["llarc"], lang: :asciimath)],
          mathml: ["&#x25df;"],
          latex: [["llarc", "&#x25df;"]],
          omml: ["&#x25df;"],
          html: ["&#x25df;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\llarc"
        end

        def to_asciimath(**)
          parsing_wrapper("llarc", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25df;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25df;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25df;"
        end

        def to_html(**)
          "&#x25df;"
        end
      end
    end
  end
end
