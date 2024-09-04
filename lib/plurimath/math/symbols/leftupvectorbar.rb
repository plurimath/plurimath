module Plurimath
  module Math
    module Symbols
      class Leftupvectorbar < Symbol
        INPUT = {
          unicodemath: [["&#x2958;"], parsing_wrapper(["barupharpoonleft", "LeftUpVectorBar"], lang: :unicode)],
          asciimath: [["&#x2958;"], parsing_wrapper(["barupharpoonleft", "LeftUpVectorBar"], lang: :asciimath)],
          mathml: ["&#x2958;"],
          latex: [["barupharpoonleft", "LeftUpVectorBar", "&#x2958;"]],
          omml: ["&#x2958;"],
          html: ["&#x2958;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\barupharpoonleft"
        end

        def to_asciimath(**)
          parsing_wrapper("LeftUpVectorBar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2958;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2958;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2958;"
        end

        def to_html(**)
          "&#x2958;"
        end
      end
    end
  end
end
