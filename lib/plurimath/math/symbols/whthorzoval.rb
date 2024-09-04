module Plurimath
  module Math
    module Symbols
      class Whthorzoval < Symbol
        INPUT = {
          unicodemath: [["&#x2b2d;"], parsing_wrapper(["whthorzoval"], lang: :unicode)],
          asciimath: [["&#x2b2d;"], parsing_wrapper(["whthorzoval"], lang: :asciimath)],
          mathml: ["&#x2b2d;"],
          latex: [["whthorzoval", "&#x2b2d;"]],
          omml: ["&#x2b2d;"],
          html: ["&#x2b2d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\whthorzoval"
        end

        def to_asciimath(**)
          parsing_wrapper("whthorzoval", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b2d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b2d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b2d;"
        end

        def to_html(**)
          "&#x2b2d;"
        end
      end
    end
  end
end
