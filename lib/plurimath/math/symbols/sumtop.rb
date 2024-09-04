module Plurimath
  module Math
    module Symbols
      class Sumtop < Symbol
        INPUT = {
          unicodemath: [["&#x23b2;"], parsing_wrapper(["sumtop"], lang: :unicode)],
          asciimath: [["&#x23b2;"], parsing_wrapper(["sumtop"], lang: :asciimath)],
          mathml: ["&#x23b2;"],
          latex: [["sumtop", "&#x23b2;"]],
          omml: ["&#x23b2;"],
          html: ["&#x23b2;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\sumtop"
        end

        def to_asciimath(**)
          parsing_wrapper("sumtop", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23b2;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23b2;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23b2;"
        end

        def to_html(**)
          "&#x23b2;"
        end
      end
    end
  end
end
