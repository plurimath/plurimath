module Plurimath
  module Math
    module Symbols
      class Leqq < Symbol
        INPUT = {
          unicodemath: [["leqq", "&#x2266;"]],
          asciimath: [["&#x2266;"], parsing_wrapper(["leqq"], lang: :asciimath)],
          mathml: ["&#x2266;"],
          latex: [["leqq", "&#x2266;"]],
          omml: ["&#x2266;"],
          html: ["&#x2266;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leqq"
        end

        def to_asciimath(**)
          parsing_wrapper("leqq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2266;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2266;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2266;"
        end

        def to_html(**)
          "&#x2266;"
        end
      end
    end
  end
end
