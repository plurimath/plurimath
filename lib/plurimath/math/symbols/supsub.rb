module Plurimath
  module Math
    module Symbols
      class Supsub < Symbol
        INPUT = {
          unicodemath: [["supsub", "&#x2ad4;"]],
          asciimath: [["&#x2ad4;"], parsing_wrapper(["supsub"], lang: :asciimath)],
          mathml: ["&#x2ad4;"],
          latex: [["supsub", "&#x2ad4;"]],
          omml: ["&#x2ad4;"],
          html: ["&#x2ad4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\supsub"
        end

        def to_asciimath(**)
          parsing_wrapper("supsub", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ad4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ad4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ad4;"
        end

        def to_html(**)
          "&#x2ad4;"
        end
      end
    end
  end
end
