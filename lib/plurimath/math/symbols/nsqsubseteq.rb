module Plurimath
  module Math
    module Symbols
      class Nsqsubseteq < Symbol
        INPUT = {
          unicodemath: [["nsqsubseteq", "&#x22e2;"]],
          asciimath: [["&#x22e2;"], parsing_wrapper(["nsqsubseteq"], lang: :asciimath)],
          mathml: ["&#x22e2;"],
          latex: [["nsqsubseteq", "&#x22e2;"]],
          omml: ["&#x22e2;"],
          html: ["&#x22e2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nsqsubseteq"
        end

        def to_asciimath(**)
          parsing_wrapper("nsqsubseteq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22e2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22e2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22e2;"
        end

        def to_html(**)
          "&#x22e2;"
        end
      end
    end
  end
end
