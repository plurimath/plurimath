module Plurimath
  module Math
    module Symbols
      class Jupiter < Symbol
        INPUT = {
          unicodemath: [["&#x2643;"], parsing_wrapper(["jupiter", "Jupiter"], lang: :unicode)],
          asciimath: [["&#x2643;"], parsing_wrapper(["jupiter", "Jupiter"], lang: :asciimath)],
          mathml: ["&#x2643;"],
          latex: [["jupiter", "Jupiter", "&#x2643;"]],
          omml: ["&#x2643;"],
          html: ["&#x2643;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\jupiter"
        end

        def to_asciimath(**)
          parsing_wrapper("Jupiter", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2643;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2643;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2643;"
        end

        def to_html(**)
          "&#x2643;"
        end
      end
    end
  end
end
