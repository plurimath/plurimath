module Plurimath
  module Math
    module Symbols
      class Bnot < Symbol
        INPUT = {
          unicodemath: [["&#x2aed;"], parsing_wrapper(["bNot"], lang: :unicode)],
          asciimath: [["&#x2aed;"], parsing_wrapper(["bNot"], lang: :asciimath)],
          mathml: ["&#x2aed;"],
          latex: [["bNot", "&#x2aed;"]],
          omml: ["&#x2aed;"],
          html: ["&#x2aed;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bNot"
        end

        def to_asciimath(**)
          parsing_wrapper("bNot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2aed;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2aed;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2aed;"
        end

        def to_html(**)
          "&#x2aed;"
        end
      end
    end
  end
end
