module Plurimath
  module Math
    module Symbols
      class Gtrapprox < Symbol
        INPUT = {
          unicodemath: [["&#x2a86;"], parsing_wrapper(["gtrapprox"], lang: :unicode)],
          asciimath: [["&#x2a86;"], parsing_wrapper(["gtrapprox"], lang: :asciimath)],
          mathml: ["&#x2a86;"],
          latex: [["gtrapprox", "&#x2a86;"]],
          omml: ["&#x2a86;"],
          html: ["&#x2a86;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gtrapprox"
        end

        def to_asciimath(**)
          parsing_wrapper("gtrapprox", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a86;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a86;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a86;"
        end

        def to_html(**)
          "&#x2a86;"
        end
      end
    end
  end
end
