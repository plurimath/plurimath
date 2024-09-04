module Plurimath
  module Math
    module Symbols
      class Gets < Symbol
        INPUT = {
          unicodemath: [["gets", "leftarrow", "&#x2190;"], parsing_wrapper(["larr"], lang: :unicode)],
          asciimath: [["leftarrow", "larr", "&#x2190;"], parsing_wrapper(["gets"], lang: :asciimath)],
          mathml: ["&#x2190;"],
          latex: [["leftarrow", "gets", "&#x2190;"], parsing_wrapper(["larr"], lang: :latex)],
          omml: ["&#x2190;"],
          html: ["&#x2190;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gets"
        end

        def to_asciimath(**)
          "larr"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2190;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#x2190;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2190;"
        end

        def to_html(**)
          "&#x2190;"
        end
      end
    end
  end
end
