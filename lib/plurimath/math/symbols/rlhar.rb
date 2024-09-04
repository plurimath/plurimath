module Plurimath
  module Math
    module Symbols
      class Rlhar < Symbol
        INPUT = {
          unicodemath: [["rightleftharpoons", "rlhar", "&#x21cc;"], parsing_wrapper(["equilibrium"], lang: :unicode)],
          asciimath: [["&#x21cc;"], parsing_wrapper(["rightleftharpoons", "rlhar", "equilibrium"], lang: :asciimath)],
          mathml: ["&#x21cc;"],
          latex: [["rightleftharpoons", "equilibrium", "&#x21cc;"], parsing_wrapper(["rlhar"], lang: :latex)],
          omml: ["&#x21cc;"],
          html: ["&#x21cc;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightleftharpoons"
        end

        def to_asciimath(**)
          parsing_wrapper("rlhar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21cc;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21cc;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21cc;"
        end

        def to_html(**)
          "&#x21cc;"
        end
      end
    end
  end
end
