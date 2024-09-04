module Plurimath
  module Math
    module Symbols
      class Aries < Symbol
        INPUT = {
          unicodemath: [["&#x2648;"], parsing_wrapper(["aries", "Aries"], lang: :unicode)],
          asciimath: [["&#x2648;"], parsing_wrapper(["aries", "Aries"], lang: :asciimath)],
          mathml: ["&#x2648;"],
          latex: [["aries", "Aries", "&#x2648;"]],
          omml: ["&#x2648;"],
          html: ["&#x2648;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\aries"
        end

        def to_asciimath(**)
          parsing_wrapper("Aries", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2648;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2648;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2648;"
        end

        def to_html(**)
          "&#x2648;"
        end
      end
    end
  end
end
