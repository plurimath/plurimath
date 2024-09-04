module Plurimath
  module Math
    module Symbols
      class Rightturn < Symbol
        INPUT = {
          unicodemath: [["circlearrowright", "&#x21bb;"], parsing_wrapper(["cwopencirclearrow", "rightturn"], lang: :unicode)],
          asciimath: [["&#x21bb;"], parsing_wrapper(["circlearrowright", "cwopencirclearrow", "rightturn"], lang: :asciimath)],
          mathml: ["&#x21bb;"],
          latex: [["cwopencirclearrow", "circlearrowright", "rightturn", "&#x21bb;"]],
          omml: ["&#x21bb;"],
          html: ["&#x21bb;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\cwopencirclearrow"
        end

        def to_asciimath(**)
          parsing_wrapper("rightturn", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21bb;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21bb;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21bb;"
        end

        def to_html(**)
          "&#x21bb;"
        end
      end
    end
  end
end
