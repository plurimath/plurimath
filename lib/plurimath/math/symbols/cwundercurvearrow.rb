module Plurimath
  module Math
    module Symbols
      class Cwundercurvearrow < Symbol
        INPUT = {
          unicodemath: [["&#x293e;"], parsing_wrapper(["cwundercurvearrow"], lang: :unicode)],
          asciimath: [["&#x293e;"], parsing_wrapper(["cwundercurvearrow"], lang: :asciimath)],
          mathml: ["&#x293e;"],
          latex: [["cwundercurvearrow", "&#x293e;"]],
          omml: ["&#x293e;"],
          html: ["&#x293e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\cwundercurvearrow"
        end

        def to_asciimath(**)
          parsing_wrapper("cwundercurvearrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x293e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x293e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x293e;"
        end

        def to_html(**)
          "&#x293e;"
        end
      end
    end
  end
end
