module Plurimath
  module Math
    module Symbols
      class Dottedcircle < Symbol
        INPUT = {
          unicodemath: [["&#x25cc;"], parsing_wrapper(["dottedcircle"], lang: :unicode)],
          asciimath: [["&#x25cc;"], parsing_wrapper(["dottedcircle"], lang: :asciimath)],
          mathml: ["&#x25cc;"],
          latex: [["dottedcircle", "&#x25cc;"]],
          omml: ["&#x25cc;"],
          html: ["&#x25cc;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\dottedcircle"
        end

        def to_asciimath(**)
          parsing_wrapper("dottedcircle", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25cc;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25cc;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25cc;"
        end

        def to_html(**)
          "&#x25cc;"
        end
      end
    end
  end
end
