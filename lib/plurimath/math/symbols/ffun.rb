module Plurimath
  module Math
    module Symbols
      class Ffun < Symbol
        INPUT = {
          unicodemath: [["&#x21fb;"], parsing_wrapper(["nVrightarrow", "ffun"], lang: :unicode)],
          asciimath: [["&#x21fb;"], parsing_wrapper(["nVrightarrow", "ffun"], lang: :asciimath)],
          mathml: ["&#x21fb;"],
          latex: [["nVrightarrow", "ffun", "&#x21fb;"]],
          omml: ["&#x21fb;"],
          html: ["&#x21fb;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nVrightarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("ffun", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21fb;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21fb;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21fb;"
        end

        def to_html(**)
          "&#x21fb;"
        end
      end
    end
  end
end
