module Plurimath
  module Math
    module Symbols
      class Maltese < Symbol
        INPUT = {
          unicodemath: [["&#x2720;"], parsing_wrapper(["maltese"], lang: :unicode)],
          asciimath: [["&#x2720;"], parsing_wrapper(["maltese"], lang: :asciimath)],
          mathml: ["&#x2720;"],
          latex: [["maltese", "&#x2720;"]],
          omml: ["&#x2720;"],
          html: ["&#x2720;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\maltese"
        end

        def to_asciimath(**)
          parsing_wrapper("maltese", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2720;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2720;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2720;"
        end

        def to_html(**)
          "&#x2720;"
        end
      end
    end
  end
end
