module Plurimath
  module Math
    module Symbols
      class Barcap < Symbol
        INPUT = {
          unicodemath: [["&#x2a43;"], parsing_wrapper(["barcap"], lang: :unicode)],
          asciimath: [["&#x2a43;"], parsing_wrapper(["barcap"], lang: :asciimath)],
          mathml: ["&#x2a43;"],
          latex: [["barcap", "&#x2a43;"]],
          omml: ["&#x2a43;"],
          html: ["&#x2a43;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\barcap"
        end

        def to_asciimath(**)
          parsing_wrapper("barcap", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a43;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a43;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a43;"
        end

        def to_html(**)
          "&#x2a43;"
        end
      end
    end
  end
end
