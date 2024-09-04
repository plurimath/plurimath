module Plurimath
  module Math
    module Symbols
      class Droang < Symbol
        INPUT = {
          unicodemath: [["&#x31a;"], parsing_wrapper(["droang"], lang: :unicode)],
          asciimath: [["&#x31a;"], parsing_wrapper(["droang"], lang: :asciimath)],
          mathml: ["&#x31a;"],
          latex: [["droang", "&#x31a;"]],
          omml: ["&#x31a;"],
          html: ["&#x31a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\droang"
        end

        def to_asciimath(**)
          parsing_wrapper("droang", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x31a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x31a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x31a;"
        end

        def to_html(**)
          "&#x31a;"
        end
      end
    end
  end
end
