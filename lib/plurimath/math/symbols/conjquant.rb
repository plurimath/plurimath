module Plurimath
  module Math
    module Symbols
      class Conjquant < Symbol
        INPUT = {
          unicodemath: [["&#x2a07;"], parsing_wrapper(["conjquant"], lang: :unicode)],
          asciimath: [["&#x2a07;"], parsing_wrapper(["conjquant"], lang: :asciimath)],
          mathml: ["&#x2a07;"],
          latex: [["conjquant", "&#x2a07;"]],
          omml: ["&#x2a07;"],
          html: ["&#x2a07;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\conjquant"
        end

        def to_asciimath(**)
          parsing_wrapper("conjquant", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a07;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a07;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a07;"
        end

        def to_html(**)
          "&#x2a07;"
        end
      end
    end
  end
end
