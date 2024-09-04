module Plurimath
  module Math
    module Symbols
      class Sqsubsetneq < Symbol
        INPUT = {
          unicodemath: [["&#x22e4;"], parsing_wrapper(["sqsubsetneq"], lang: :unicode)],
          asciimath: [["&#x22e4;"], parsing_wrapper(["sqsubsetneq"], lang: :asciimath)],
          mathml: ["&#x22e4;"],
          latex: [["sqsubsetneq", "&#x22e4;"]],
          omml: ["&#x22e4;"],
          html: ["&#x22e4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sqsubsetneq"
        end

        def to_asciimath(**)
          parsing_wrapper("sqsubsetneq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22e4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22e4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22e4;"
        end

        def to_html(**)
          "&#x22e4;"
        end
      end
    end
  end
end
