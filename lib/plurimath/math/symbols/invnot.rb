module Plurimath
  module Math
    module Symbols
      class Invnot < Symbol
        INPUT = {
          unicodemath: [["&#x2310;"], parsing_wrapper(["invneg", "invnot"], lang: :unicode)],
          asciimath: [["&#x2310;"], parsing_wrapper(["invneg", "invnot"], lang: :asciimath)],
          mathml: ["&#x2310;"],
          latex: [["invneg", "invnot", "&#x2310;"]],
          omml: ["&#x2310;"],
          html: ["&#x2310;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\invneg"
        end

        def to_asciimath(**)
          parsing_wrapper("invnot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2310;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2310;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2310;"
        end

        def to_html(**)
          "&#x2310;"
        end
      end
    end
  end
end
