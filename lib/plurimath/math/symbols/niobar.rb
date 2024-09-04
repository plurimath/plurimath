module Plurimath
  module Math
    module Symbols
      class Niobar < Symbol
        INPUT = {
          unicodemath: [["&#x22fe;"], parsing_wrapper(["niobar"], lang: :unicode)],
          asciimath: [["&#x22fe;"], parsing_wrapper(["niobar"], lang: :asciimath)],
          mathml: ["&#x22fe;"],
          latex: [["niobar", "&#x22fe;"]],
          omml: ["&#x22fe;"],
          html: ["&#x22fe;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\niobar"
        end

        def to_asciimath(**)
          parsing_wrapper("niobar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22fe;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22fe;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22fe;"
        end

        def to_html(**)
          "&#x22fe;"
        end
      end
    end
  end
end
