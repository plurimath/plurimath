module Plurimath
  module Math
    module Symbols
      class Vvdash < Symbol
        INPUT = {
          unicodemath: [["Vvdash", "&#x22aa;"]],
          asciimath: [["&#x22aa;"], parsing_wrapper(["Vvdash"], lang: :asciimath)],
          mathml: ["&#x22aa;"],
          latex: [["Vvdash", "&#x22aa;"]],
          omml: ["&#x22aa;"],
          html: ["&#x22aa;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Vvdash"
        end

        def to_asciimath(**)
          parsing_wrapper("Vvdash", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22aa;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22aa;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22aa;"
        end

        def to_html(**)
          "&#x22aa;"
        end
      end
    end
  end
end
