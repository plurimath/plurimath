module Plurimath
  module Math
    module Symbols
      class Lparenextender < Symbol
        INPUT = {
          unicodemath: [["&#x239c;"], parsing_wrapper(["lparenextender"], lang: :unicode)],
          asciimath: [["&#x239c;"], parsing_wrapper(["lparenextender"], lang: :asciimath)],
          mathml: ["&#x239c;"],
          latex: [["lparenextender", "&#x239c;"]],
          omml: ["&#x239c;"],
          html: ["&#x239c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lparenextender"
        end

        def to_asciimath(**)
          parsing_wrapper("lparenextender", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x239c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x239c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x239c;"
        end

        def to_html(**)
          "&#x239c;"
        end
      end
    end
  end
end
