module Plurimath
  module Math
    module Symbols
      class Lbracklltick < Symbol
        INPUT = {
          unicodemath: [["&#x298f;"], parsing_wrapper(["lbracklltick"], lang: :unicode)],
          asciimath: [["&#x298f;"], parsing_wrapper(["lbracklltick"], lang: :asciimath)],
          mathml: ["&#x298f;"],
          latex: [["lbracklltick", "&#x298f;"]],
          omml: ["&#x298f;"],
          html: ["&#x298f;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lbracklltick"
        end

        def to_asciimath(**)
          parsing_wrapper("lbracklltick", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x298f;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x298f;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x298f;"
        end

        def to_html(**)
          "&#x298f;"
        end
      end
    end
  end
end
