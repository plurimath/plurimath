module Plurimath
  module Math
    module Symbols
      class Harr < Symbol
        INPUT = {
          unicodemath: [["Leftrightarrow", "&#x21d4;"], parsing_wrapper(["<=>", "hArr", "iff"], lang: :unicode)],
          asciimath: [["Leftrightarrow", "<=>", "hArr", "iff", "&#x21d4;"]],
          mathml: ["&#x21d4;"],
          latex: [["Leftrightarrow", "&#x21d4;"], parsing_wrapper(["<=>", "hArr", "iff"], lang: :latex)],
          omml: ["&#x21d4;"],
          html: ["&#x21d4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\hArr"
        end

        def to_asciimath(**)
          "hArr"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21d4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21d4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21d4;"
        end

        def to_html(**)
          "&#x21d4;"
        end
      end
    end
  end
end
