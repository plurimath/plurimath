module Plurimath
  module Math
    module Symbols
      class Wr < Symbol
        INPUT = {
          unicodemath: [["wr", "&#x2240;"]],
          asciimath: [["&#x2240;"], parsing_wrapper(["wr"], lang: :asciimath)],
          mathml: ["&#x2240;"],
          latex: [["wr", "&#x2240;"]],
          omml: ["&#x2240;"],
          html: ["&#x2240;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\wr"
        end

        def to_asciimath(**)
          parsing_wrapper("wr", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2240;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2240;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2240;"
        end

        def to_html(**)
          "&#x2240;"
        end
      end
    end
  end
end
