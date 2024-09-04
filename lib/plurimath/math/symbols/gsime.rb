module Plurimath
  module Math
    module Symbols
      class Gsime < Symbol
        INPUT = {
          unicodemath: [["&#x2a8e;"], parsing_wrapper(["gsime"], lang: :unicode)],
          asciimath: [["&#x2a8e;"], parsing_wrapper(["gsime"], lang: :asciimath)],
          mathml: ["&#x2a8e;"],
          latex: [["gsime", "&#x2a8e;"]],
          omml: ["&#x2a8e;"],
          html: ["&#x2a8e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gsime"
        end

        def to_asciimath(**)
          parsing_wrapper("gsime", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a8e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a8e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a8e;"
        end

        def to_html(**)
          "&#x2a8e;"
        end
      end
    end
  end
end
