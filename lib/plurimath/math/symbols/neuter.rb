module Plurimath
  module Math
    module Symbols
      class Neuter < Symbol
        INPUT = {
          unicodemath: [["&#x26b2;"], parsing_wrapper(["neuter"], lang: :unicode)],
          asciimath: [["&#x26b2;"], parsing_wrapper(["neuter"], lang: :asciimath)],
          mathml: ["&#x26b2;"],
          latex: [["neuter", "&#x26b2;"]],
          omml: ["&#x26b2;"],
          html: ["&#x26b2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\neuter"
        end

        def to_asciimath(**)
          parsing_wrapper("neuter", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x26b2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x26b2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x26b2;"
        end

        def to_html(**)
          "&#x26b2;"
        end
      end
    end
  end
end
