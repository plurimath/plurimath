module Plurimath
  module Math
    module Symbols
      class Sqsubseteq < Symbol
        INPUT = {
          unicodemath: [["sqsubseteq", "&#x2291;"]],
          asciimath: [["&#x2291;"], parsing_wrapper(["sqsubseteq"], lang: :asciimath)],
          mathml: ["&#x2291;"],
          latex: [["sqsubseteq", "&#x2291;"]],
          omml: ["&#x2291;"],
          html: ["&#x2291;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sqsubseteq"
        end

        def to_asciimath(**)
          parsing_wrapper("sqsubseteq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2291;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2291;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2291;"
        end

        def to_html(**)
          "&#x2291;"
        end
      end
    end
  end
end
