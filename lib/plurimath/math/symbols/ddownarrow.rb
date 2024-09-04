module Plurimath
  module Math
    module Symbols
      class Ddownarrow < Symbol
        INPUT = {
          unicodemath: [["&#x290b;"], parsing_wrapper(["Ddownarrow"], lang: :unicode)],
          asciimath: [["&#x290b;"], parsing_wrapper(["Ddownarrow"], lang: :asciimath)],
          mathml: ["&#x290b;"],
          latex: [["Ddownarrow", "&#x290b;"]],
          omml: ["&#x290b;"],
          html: ["&#x290b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Ddownarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("Ddownarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x290b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x290b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x290b;"
        end

        def to_html(**)
          "&#x290b;"
        end
      end
    end
  end
end
