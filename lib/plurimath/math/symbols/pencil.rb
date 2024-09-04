module Plurimath
  module Math
    module Symbols
      class Pencil < Symbol
        INPUT = {
          unicodemath: [["&#x270e;"], parsing_wrapper(["pencil"], lang: :unicode)],
          asciimath: [["&#x270e;"], parsing_wrapper(["pencil"], lang: :asciimath)],
          mathml: ["&#x270e;"],
          latex: [["pencil", "&#x270e;"]],
          omml: ["&#x270e;"],
          html: ["&#x270e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\pencil"
        end

        def to_asciimath(**)
          parsing_wrapper("pencil", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x270e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x270e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x270e;"
        end

        def to_html(**)
          "&#x270e;"
        end
      end
    end
  end
end
