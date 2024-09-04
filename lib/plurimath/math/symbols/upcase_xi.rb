module Plurimath
  module Math
    module Symbols
      class UpcaseXi < Symbol
        INPUT = {
          unicodemath: [["Xi", "&#x39e;"], parsing_wrapper(["upXi"], lang: :unicode)],
          asciimath: [["Xi", "&#x39e;"], parsing_wrapper(["upXi"], lang: :asciimath)],
          mathml: ["&#x39e;"],
          latex: [["upXi", "Xi", "&#x39e;"]],
          omml: ["&#x39e;"],
          html: ["&#x39e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Xi"
        end

        def to_asciimath(**)
          "Xi"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x39e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x39e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x39e;"
        end

        def to_html(**)
          "&#x39e;"
        end
      end
    end
  end
end
