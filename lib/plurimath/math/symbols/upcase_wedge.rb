module Plurimath
  module Math
    module Symbols
      class UpcaseWedge < Symbol
        INPUT = {
          unicodemath: [["&#x2a53;"], parsing_wrapper(["UpcaseWedge"], lang: :unicode)],
          asciimath: [["&#x2a53;"], parsing_wrapper(["UpcaseWedge"], lang: :asciimath)],
          mathml: ["&#x2a53;"],
          latex: [["Wedge", "&#x2a53;"]],
          omml: ["&#x2a53;"],
          html: ["&#x2a53;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Wedge"
        end

        def to_asciimath(**)
          parsing_wrapper("Wedge", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a53;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a53;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a53;"
        end

        def to_html(**)
          "&#x2a53;"
        end
      end
    end
  end
end
