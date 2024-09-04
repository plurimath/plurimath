module Plurimath
  module Math
    module Symbols
      class Rightbarharpoon < Symbol
        INPUT = {
          unicodemath: [["&#x296c;"], parsing_wrapper(["rightharpoonupdash", "rightbarharpoon"], lang: :unicode)],
          asciimath: [["&#x296c;"], parsing_wrapper(["rightharpoonupdash", "rightbarharpoon"], lang: :asciimath)],
          mathml: ["&#x296c;"],
          latex: [["rightharpoonupdash", "rightbarharpoon", "&#x296c;"]],
          omml: ["&#x296c;"],
          html: ["&#x296c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightharpoonupdash"
        end

        def to_asciimath(**)
          parsing_wrapper("rightbarharpoon", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x296c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x296c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x296c;"
        end

        def to_html(**)
          "&#x296c;"
        end
      end
    end
  end
end
