module Plurimath
  module Math
    module Symbols
      class Geqslant < Symbol
        INPUT = {
          unicodemath: [["&#x2a7e;"], parsing_wrapper(["geqslant"], lang: :unicode)],
          asciimath: [["&#x2a7e;"], parsing_wrapper(["geqslant"], lang: :asciimath)],
          mathml: ["&#x2a7e;"],
          latex: [["geqslant", "&#x2a7e;"]],
          omml: ["&#x2a7e;"],
          html: ["&#x2a7e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\geqslant"
        end

        def to_asciimath(**)
          parsing_wrapper("geqslant", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a7e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a7e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a7e;"
        end

        def to_html(**)
          "&#x2a7e;"
        end
      end
    end
  end
end
