module Plurimath
  module Math
    module Symbols
      class Whitearrowupfrombar < Symbol
        INPUT = {
          unicodemath: [["&#x21ea;"], parsing_wrapper(["whitearrowupfrombar"], lang: :unicode)],
          asciimath: [["&#x21ea;"], parsing_wrapper(["whitearrowupfrombar"], lang: :asciimath)],
          mathml: ["&#x21ea;"],
          latex: [["whitearrowupfrombar", "&#x21ea;"]],
          omml: ["&#x21ea;"],
          html: ["&#x21ea;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\whitearrowupfrombar"
        end

        def to_asciimath(**)
          parsing_wrapper("whitearrowupfrombar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21ea;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21ea;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21ea;"
        end

        def to_html(**)
          "&#x21ea;"
        end
      end
    end
  end
end
