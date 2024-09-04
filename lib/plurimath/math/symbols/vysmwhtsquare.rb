module Plurimath
  module Math
    module Symbols
      class Vysmwhtsquare < Symbol
        INPUT = {
          unicodemath: [["&#x2b1e;"], parsing_wrapper(["vysmwhtsquare"], lang: :unicode)],
          asciimath: [["&#x2b1e;"], parsing_wrapper(["vysmwhtsquare"], lang: :asciimath)],
          mathml: ["&#x2b1e;"],
          latex: [["vysmwhtsquare", "&#x2b1e;"]],
          omml: ["&#x2b1e;"],
          html: ["&#x2b1e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\vysmwhtsquare"
        end

        def to_asciimath(**)
          parsing_wrapper("vysmwhtsquare", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b1e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b1e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b1e;"
        end

        def to_html(**)
          "&#x2b1e;"
        end
      end
    end
  end
end
