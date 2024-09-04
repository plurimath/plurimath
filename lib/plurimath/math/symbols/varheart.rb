module Plurimath
  module Math
    module Symbols
      class Varheart < Symbol
        INPUT = {
          unicodemath: [["&#x2665;"], parsing_wrapper(["varheartsuit", "varheart"], lang: :unicode)],
          asciimath: [["&#x2665;"], parsing_wrapper(["varheartsuit", "varheart"], lang: :asciimath)],
          mathml: ["&#x2665;"],
          latex: [["varheartsuit", "varheart", "&#x2665;"]],
          omml: ["&#x2665;"],
          html: ["&#x2665;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\varheartsuit"
        end

        def to_asciimath(**)
          parsing_wrapper("varheart", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2665;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2665;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2665;"
        end

        def to_html(**)
          "&#x2665;"
        end
      end
    end
  end
end
