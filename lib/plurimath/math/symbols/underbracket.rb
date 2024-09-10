module Plurimath
  module Math
    module Symbols
      class Underbracket < Symbol
        INPUT = {
          unicodemath: [["&#x23b5;"], parsing_wrapper(["underbracket"], lang: :unicode)],
          asciimath: [["&#x23b5;"], parsing_wrapper(["underbracket"], lang: :asciimath)],
          mathml: ["&#x23b5;"],
          latex: [["underbracket", "&#x23b5;"]],
          omml: ["&#x23b5;"],
          html: ["&#x23b5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\underbracket"
        end

        def to_asciimath(**)
          parsing_wrapper("underbracket", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23b5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23b5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23b5;"
        end

        def to_html(**)
          "&#x23b5;"
        end
      end
    end
  end
end
