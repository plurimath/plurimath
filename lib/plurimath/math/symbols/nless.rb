module Plurimath
  module Math
    module Symbols
      class Nless < Symbol
        INPUT = {
          unicodemath: [["nless", "&#x226e;"]],
          asciimath: [["&#x226e;"], parsing_wrapper(["nless"], lang: :asciimath)],
          mathml: ["&#x226e;"],
          latex: [["nless", "&#x226e;"]],
          omml: ["&#x226e;"],
          html: ["&#x226e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nless"
        end

        def to_asciimath(**)
          parsing_wrapper("nless", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x226e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x226e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x226e;"
        end

        def to_html(**)
          "&#x226e;"
        end
      end
    end
  end
end
