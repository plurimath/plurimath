module Plurimath
  module Math
    module Symbols
      class Plusdot < Symbol
        INPUT = {
          unicodemath: [["&#x2a25;"], parsing_wrapper(["plusdot"], lang: :unicode)],
          asciimath: [["&#x2a25;"], parsing_wrapper(["plusdot"], lang: :asciimath)],
          mathml: ["&#x2a25;"],
          latex: [["plusdot", "&#x2a25;"]],
          omml: ["&#x2a25;"],
          html: ["&#x2a25;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\plusdot"
        end

        def to_asciimath(**)
          parsing_wrapper("plusdot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a25;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a25;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a25;"
        end

        def to_html(**)
          "&#x2a25;"
        end
      end
    end
  end
end
