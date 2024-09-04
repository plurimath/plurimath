module Plurimath
  module Math
    module Symbols
      class Veedoublebar < Symbol
        INPUT = {
          unicodemath: [["&#x2a63;"], parsing_wrapper(["veedoublebar"], lang: :unicode)],
          asciimath: [["&#x2a63;"], parsing_wrapper(["veedoublebar"], lang: :asciimath)],
          mathml: ["&#x2a63;"],
          latex: [["veedoublebar", "&#x2a63;"]],
          omml: ["&#x2a63;"],
          html: ["&#x2a63;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\veedoublebar"
        end

        def to_asciimath(**)
          parsing_wrapper("veedoublebar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a63;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a63;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a63;"
        end

        def to_html(**)
          "&#x2a63;"
        end
      end
    end
  end
end
