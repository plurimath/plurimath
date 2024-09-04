module Plurimath
  module Math
    module Symbols
      class Eth < Symbol
        INPUT = {
          unicodemath: [["&#xf0;"], parsing_wrapper(["matheth", "eth"], lang: :unicode)],
          asciimath: [["&#xf0;"], parsing_wrapper(["matheth", "eth"], lang: :asciimath)],
          mathml: ["&#xf0;"],
          latex: [["matheth", "eth", "&#xf0;"]],
          omml: ["&#xf0;"],
          html: ["&#xf0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\matheth"
        end

        def to_asciimath(**)
          parsing_wrapper("eth", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#xf0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#xf0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#xf0;"
        end

        def to_html(**)
          "&#xf0;"
        end
      end
    end
  end
end
