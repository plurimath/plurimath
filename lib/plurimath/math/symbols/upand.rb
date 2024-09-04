module Plurimath
  module Math
    module Symbols
      class Upand < Symbol
        INPUT = {
          unicodemath: [["&#x214b;"], parsing_wrapper(["invamp", "upand"], lang: :unicode)],
          asciimath: [["&#x214b;"], parsing_wrapper(["invamp", "upand"], lang: :asciimath)],
          mathml: ["&#x214b;"],
          latex: [["invamp", "upand", "&#x214b;"]],
          omml: ["&#x214b;"],
          html: ["&#x214b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\invamp"
        end

        def to_asciimath(**)
          parsing_wrapper("upand", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x214b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x214b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x214b;"
        end

        def to_html(**)
          "&#x214b;"
        end
      end
    end
  end
end
