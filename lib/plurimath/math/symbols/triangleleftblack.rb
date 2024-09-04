module Plurimath
  module Math
    module Symbols
      class Triangleleftblack < Symbol
        INPUT = {
          unicodemath: [["&#x25ed;"], parsing_wrapper(["triangleleftblack"], lang: :unicode)],
          asciimath: [["&#x25ed;"], parsing_wrapper(["triangleleftblack"], lang: :asciimath)],
          mathml: ["&#x25ed;"],
          latex: [["triangleleftblack", "&#x25ed;"]],
          omml: ["&#x25ed;"],
          html: ["&#x25ed;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\triangleleftblack"
        end

        def to_asciimath(**)
          parsing_wrapper("triangleleftblack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25ed;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25ed;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25ed;"
        end

        def to_html(**)
          "&#x25ed;"
        end
      end
    end
  end
end
