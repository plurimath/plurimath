module Plurimath
  module Math
    module Symbols
      class Leftdownteevector < Symbol
        INPUT = {
          unicodemath: [["&#x2961;"], parsing_wrapper(["bardownharpoonleft", "LeftDownTeeVector"], lang: :unicode)],
          asciimath: [["&#x2961;"], parsing_wrapper(["bardownharpoonleft", "LeftDownTeeVector"], lang: :asciimath)],
          mathml: ["&#x2961;"],
          latex: [["bardownharpoonleft", "LeftDownTeeVector", "&#x2961;"]],
          omml: ["&#x2961;"],
          html: ["&#x2961;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bardownharpoonleft"
        end

        def to_asciimath(**)
          parsing_wrapper("LeftDownTeeVector", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2961;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2961;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2961;"
        end

        def to_html(**)
          "&#x2961;"
        end
      end
    end
  end
end
