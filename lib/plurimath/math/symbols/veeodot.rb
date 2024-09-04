module Plurimath
  module Math
    module Symbols
      class Veeodot < Symbol
        INPUT = {
          unicodemath: [["&#x2a52;"], parsing_wrapper(["veeodot"], lang: :unicode)],
          asciimath: [["&#x2a52;"], parsing_wrapper(["veeodot"], lang: :asciimath)],
          mathml: ["&#x2a52;"],
          latex: [["veeodot", "&#x2a52;"]],
          omml: ["&#x2a52;"],
          html: ["&#x2a52;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\veeodot"
        end

        def to_asciimath(**)
          parsing_wrapper("veeodot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a52;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a52;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a52;"
        end

        def to_html(**)
          "&#x2a52;"
        end
      end
    end
  end
end
