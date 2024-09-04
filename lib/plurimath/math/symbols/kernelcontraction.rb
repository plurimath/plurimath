module Plurimath
  module Math
    module Symbols
      class Kernelcontraction < Symbol
        INPUT = {
          unicodemath: [["&#x223b;"], parsing_wrapper(["kernelcontraction"], lang: :unicode)],
          asciimath: [["&#x223b;"], parsing_wrapper(["kernelcontraction"], lang: :asciimath)],
          mathml: ["&#x223b;"],
          latex: [["kernelcontraction", "&#x223b;"]],
          omml: ["&#x223b;"],
          html: ["&#x223b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\kernelcontraction"
        end

        def to_asciimath(**)
          parsing_wrapper("kernelcontraction", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x223b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x223b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x223b;"
        end

        def to_html(**)
          "&#x223b;"
        end
      end
    end
  end
end
