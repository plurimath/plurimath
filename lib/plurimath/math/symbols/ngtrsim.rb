module Plurimath
  module Math
    module Symbols
      class Ngtrsim < Symbol
        INPUT = {
          unicodemath: [["&#x2275;"], parsing_wrapper(["NotGreaterTilde", "ngtrsim"], lang: :unicode)],
          asciimath: [["&#x2275;"], parsing_wrapper(["NotGreaterTilde", "ngtrsim"], lang: :asciimath)],
          mathml: ["&#x2275;"],
          latex: [["NotGreaterTilde", "ngtrsim", "&#x2275;"]],
          omml: ["&#x2275;"],
          html: ["&#x2275;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\NotGreaterTilde"
        end

        def to_asciimath(**)
          parsing_wrapper("ngtrsim", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2275;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2275;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2275;"
        end

        def to_html(**)
          "&#x2275;"
        end
      end
    end
  end
end
