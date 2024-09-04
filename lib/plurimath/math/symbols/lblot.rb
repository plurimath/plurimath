module Plurimath
  module Math
    module Symbols
      class Lblot < Symbol
        INPUT = {
          unicodemath: [["&#x2989;"], parsing_wrapper(["llangle", "lblot"], lang: :unicode)],
          asciimath: [["&#x2989;"], parsing_wrapper(["llangle", "lblot"], lang: :asciimath)],
          mathml: ["&#x2989;"],
          latex: [["llangle", "lblot", "&#x2989;"]],
          omml: ["&#x2989;"],
          html: ["&#x2989;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\llangle"
        end

        def to_asciimath(**)
          parsing_wrapper("lblot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2989;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2989;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2989;"
        end

        def to_html(**)
          "&#x2989;"
        end
      end
    end
  end
end
