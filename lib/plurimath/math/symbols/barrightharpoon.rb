module Plurimath
  module Math
    module Symbols
      class Barrightharpoon < Symbol
        INPUT = {
          unicodemath: [["&#x296d;"], parsing_wrapper(["dashrightharpoondown", "barrightharpoon"], lang: :unicode)],
          asciimath: [["&#x296d;"], parsing_wrapper(["dashrightharpoondown", "barrightharpoon"], lang: :asciimath)],
          mathml: ["&#x296d;"],
          latex: [["dashrightharpoondown", "barrightharpoon", "&#x296d;"]],
          omml: ["&#x296d;"],
          html: ["&#x296d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\dashrightharpoondown"
        end

        def to_asciimath(**)
          parsing_wrapper("barrightharpoon", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x296d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x296d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x296d;"
        end

        def to_html(**)
          "&#x296d;"
        end
      end
    end
  end
end
