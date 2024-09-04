module Plurimath
  module Math
    module Symbols
      class Degc < Symbol
        INPUT = {
          unicodemath: [["degc", "&#x2103;"]],
          asciimath: [["&#x2103;"], parsing_wrapper(["degc"], lang: :asciimath)],
          mathml: ["&#x2103;"],
          latex: [["&#x2103;"], parsing_wrapper(["degc"], lang: :latex)],
          omml: ["&#x2103;"],
          html: ["&#x2103;"],
        }.freeze

        # output methods
        def to_latex(**)
          parsing_wrapper("degc", lang: :latex)
        end

        def to_asciimath(**)
          parsing_wrapper("degc", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2103;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2103;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2103;"
        end

        def to_html(**)
          "&#x2103;"
        end
      end
    end
  end
end
