module Plurimath
  module Math
    module Symbols
      class Rr < Symbol
        INPUT = {
          unicodemath: [["&#x211d;"], parsing_wrapper(["RR"], lang: :unicode)],
          asciimath: ["RR", "&#x211d;"],
          mathml: ["&#x211d;"],
          latex: [["RR", "&#x211d;"]],
          omml: ["&#x211d;"],
          html: ["&#x211d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mathbb{R}"
        end

        def to_asciimath(**)
          "mathbb(R)"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x211d;")
        end

        def to_mathml_without_math_tag(_, **)
          Utility.update_nodes(
            ox_element("mstyle", attributes: { mathvariant: "double-struck" }),
            [ox_element("mi") << "R"],
          )
        end

        def to_omml_without_math_tag(_, **)
          "&#x211d;"
        end

        def to_html(**)
          "&#x211d;"
        end
      end
    end
  end
end
