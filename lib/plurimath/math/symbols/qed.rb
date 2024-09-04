module Plurimath
  module Math
    module Symbols
      class Qed < Symbol
        INPUT = {
          unicodemath: [["qed", "&#x220e;"], parsing_wrapper(["QED"], lang: :unicode)],
          asciimath: [["&#x220e;"], parsing_wrapper(["qed", "QED"], lang: :asciimath)],
          mathml: ["&#x220e;"],
          latex: [["QED", "&#x220e;"], parsing_wrapper(["qed"], lang: :latex)],
          omml: ["&#x220e;"],
          html: ["&#x220e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\QED"
        end

        def to_asciimath(**)
          parsing_wrapper("qed", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x220e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x220e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x220e;"
        end

        def to_html(**)
          "&#x220e;"
        end
      end
    end
  end
end
