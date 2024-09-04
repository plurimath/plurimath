module Plurimath
  module Math
    module Symbols
      class Unicodecdots < Symbol
        INPUT = {
          unicodemath: [["&#x22ef;"], parsing_wrapper(["unicodecdots"], lang: :unicode)],
          asciimath: [["&#x22ef;"], parsing_wrapper(["unicodecdots"], lang: :asciimath)],
          mathml: ["&#x22ef;"],
          latex: [["unicodecdots", "&#x22ef;"]],
          omml: ["&#x22ef;"],
          html: ["&#x22ef;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\unicodecdots"
        end

        def to_asciimath(**)
          parsing_wrapper("unicodecdots", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22ef;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22ef;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22ef;"
        end

        def to_hml(**)
          "&#x22ef;"
        end
      end
    end
  end
end
