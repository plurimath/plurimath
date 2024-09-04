module Plurimath
  module Math
    module Symbols
      class Leftupdownharpoon < Symbol
        INPUT = {
          unicodemath: [["&#x2951;"], parsing_wrapper(["updownharpoonleftleft", "leftupdownharpoon"], lang: :unicode)],
          asciimath: [["&#x2951;"], parsing_wrapper(["updownharpoonleftleft", "leftupdownharpoon"], lang: :asciimath)],
          mathml: ["&#x2951;"],
          latex: [["updownharpoonleftleft", "leftupdownharpoon", "&#x2951;"]],
          omml: ["&#x2951;"],
          html: ["&#x2951;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\updownharpoonleftleft"
        end

        def to_asciimath(**)
          parsing_wrapper("leftupdownharpoon", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2951;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2951;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2951;"
        end

        def to_html(**)
          "&#x2951;"
        end
      end
    end
  end
end
