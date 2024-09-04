module Plurimath
  module Math
    module Symbols
      class Nsqsuperseteq < Symbol
        INPUT = {
          unicodemath: [["nsqsuperseteq", "&#x22e3;"], parsing_wrapper(["nsqsupseteq"], lang: :unicode)],
          asciimath: [["&#x22e3;"], parsing_wrapper(["nsqsuperseteq", "nsqsupseteq"], lang: :asciimath)],
          mathml: ["&#x22e3;"],
          latex: [["nsqsupseteq", "&#x22e3;"], parsing_wrapper(["nsqsuperseteq"], lang: :latex)],
          omml: ["&#x22e3;"],
          html: ["&#x22e3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nsqsupseteq"
        end

        def to_asciimath(**)
          parsing_wrapper("nsqsuperseteq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22e3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22e3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22e3;"
        end

        def to_html(**)
          "&#x22e3;"
        end
      end
    end
  end
end
