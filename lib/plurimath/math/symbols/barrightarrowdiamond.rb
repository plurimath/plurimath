module Plurimath
  module Math
    module Symbols
      class Barrightarrowdiamond < Symbol
        INPUT = {
          unicodemath: [["&#x2920;"], parsing_wrapper(["barrightarrowdiamond"], lang: :unicode)],
          asciimath: [["&#x2920;"], parsing_wrapper(["barrightarrowdiamond"], lang: :asciimath)],
          mathml: ["&#x2920;"],
          latex: [["barrightarrowdiamond", "&#x2920;"]],
          omml: ["&#x2920;"],
          html: ["&#x2920;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\barrightarrowdiamond"
        end

        def to_asciimath(**)
          parsing_wrapper("barrightarrowdiamond", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2920;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2920;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2920;"
        end

        def to_html(**)
          "&#x2920;"
        end
      end
    end
  end
end
