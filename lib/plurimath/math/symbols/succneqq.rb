module Plurimath
  module Math
    module Symbols
      class Succneqq < Symbol
        INPUT = {
          unicodemath: [["&#x2ab6;"], parsing_wrapper(["succneqq"], lang: :unicode)],
          asciimath: [["&#x2ab6;"], parsing_wrapper(["succneqq"], lang: :asciimath)],
          mathml: ["&#x2ab6;"],
          latex: [["succneqq", "&#x2ab6;"]],
          omml: ["&#x2ab6;"],
          html: ["&#x2ab6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\succneqq"
        end

        def to_asciimath(**)
          parsing_wrapper("succneqq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ab6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ab6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ab6;"
        end

        def to_html(**)
          "&#x2ab6;"
        end
      end
    end
  end
end
