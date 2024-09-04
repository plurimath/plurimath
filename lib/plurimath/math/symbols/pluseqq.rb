module Plurimath
  module Math
    module Symbols
      class Pluseqq < Symbol
        INPUT = {
          unicodemath: [["&#x2a72;"], parsing_wrapper(["pluseqq"], lang: :unicode)],
          asciimath: [["&#x2a72;"], parsing_wrapper(["pluseqq"], lang: :asciimath)],
          mathml: ["&#x2a72;"],
          latex: [["pluseqq", "&#x2a72;"]],
          omml: ["&#x2a72;"],
          html: ["&#x2a72;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\pluseqq"
        end

        def to_asciimath(**)
          parsing_wrapper("pluseqq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a72;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a72;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a72;"
        end

        def to_html(**)
          "&#x2a72;"
        end
      end
    end
  end
end
