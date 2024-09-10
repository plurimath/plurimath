module Plurimath
  module Math
    module Symbols
      class Trianglerightblack < Symbol
        INPUT = {
          unicodemath: [["&#x25ee;"], parsing_wrapper(["trianglerightblack"], lang: :unicode)],
          asciimath: [["&#x25ee;"], parsing_wrapper(["trianglerightblack"], lang: :asciimath)],
          mathml: ["&#x25ee;"],
          latex: [["trianglerightblack", "&#x25ee;"]],
          omml: ["&#x25ee;"],
          html: ["&#x25ee;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\trianglerightblack"
        end

        def to_asciimath(**)
          parsing_wrapper("trianglerightblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25ee;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25ee;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25ee;"
        end

        def to_html(**)
          "&#x25ee;"
        end
      end
    end
  end
end
