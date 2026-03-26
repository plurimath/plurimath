module Plurimath
  module Math
    module Symbols
      class Nn < Symbol
        INPUT = {
          unicodemath: [["&#x2115;"], parsing_wrapper(["NN"], lang: :unicode)],
          asciimath: ["NN", "&#x2115;"],
          mathml: ["&#x2115;"],
          latex: [["NN", "&#x2115;"]],
          omml: ["&#x2115;"],
          html: ["&#x2115;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\mathbb{N}"
        end

        def to_asciimath(**)
          "mathbb(N)"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2115;")
        end

        def to_mathml_without_math_tag(_, **)
          Utility.update_nodes(
            ox_element("mstyle", attributes: { mathvariant: "double-struck" }),
            [ox_element("mi") << "N"],
          )
        end

        def to_omml_without_math_tag(_, **)
          "&#x2115;"
        end

        def to_html(**)
          "&#x2115;"
        end
      end
    end
  end
end
