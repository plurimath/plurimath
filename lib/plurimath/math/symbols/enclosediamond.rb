module Plurimath
  module Math
    module Symbols
      class Enclosediamond < Symbol
        INPUT = {
          unicodemath: [["&#x20df;"], parsing_wrapper(["enclosediamond"], lang: :unicode)],
          asciimath: [["&#x20df;"], parsing_wrapper(["enclosediamond"], lang: :asciimath)],
          mathml: ["&#x20df;"],
          latex: [["enclosediamond", "&#x20df;"]],
          omml: ["&#x20df;"],
          html: ["&#x20df;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\enclosediamond"
        end

        def to_asciimath(**)
          parsing_wrapper("enclosediamond", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x20df;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x20df;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x20df;"
        end

        def to_html(**)
          "&#x20df;"
        end
      end
    end
  end
end
