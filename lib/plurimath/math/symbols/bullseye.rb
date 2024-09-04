module Plurimath
  module Math
    module Symbols
      class Bullseye < Symbol
        INPUT = {
          unicodemath: [["&#x25ce;"], parsing_wrapper(["bullseye"], lang: :unicode)],
          asciimath: [["&#x25ce;"], parsing_wrapper(["bullseye"], lang: :asciimath)],
          mathml: ["&#x25ce;"],
          latex: [["bullseye", "&#x25ce;"]],
          omml: ["&#x25ce;"],
          html: ["&#x25ce;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bullseye"
        end

        def to_asciimath(**)
          parsing_wrapper("bullseye", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25ce;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25ce;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25ce;"
        end

        def to_html(**)
          "&#x25ce;"
        end
      end
    end
  end
end
