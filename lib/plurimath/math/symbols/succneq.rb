module Plurimath
  module Math
    module Symbols
      class Succneq < Symbol
        INPUT = {
          unicodemath: [["&#x2ab2;"], parsing_wrapper(["succneq"], lang: :unicode)],
          asciimath: [["&#x2ab2;"], parsing_wrapper(["succneq"], lang: :asciimath)],
          mathml: ["&#x2ab2;"],
          latex: [["succneq", "&#x2ab2;"]],
          omml: ["&#x2ab2;"],
          html: ["&#x2ab2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\succneq"
        end

        def to_asciimath(**)
          parsing_wrapper("succneq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ab2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ab2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ab2;"
        end

        def to_html(**)
          "&#x2ab2;"
        end
      end
    end
  end
end
