module Plurimath
  module Math
    module Symbols
      class Capdot < Symbol
        INPUT = {
          unicodemath: [["&#x2a40;"], parsing_wrapper(["capdot"], lang: :unicode)],
          asciimath: [["&#x2a40;"], parsing_wrapper(["capdot"], lang: :asciimath)],
          mathml: ["&#x2a40;"],
          latex: [["capdot", "&#x2a40;"]],
          omml: ["&#x2a40;"],
          html: ["&#x2a40;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\capdot"
        end

        def to_asciimath(**)
          parsing_wrapper("capdot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a40;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a40;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a40;"
        end

        def to_html(**)
          "&#x2a40;"
        end
      end
    end
  end
end
