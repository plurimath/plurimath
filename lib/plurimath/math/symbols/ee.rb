module Plurimath
  module Math
    module Symbols
      class Ee < Symbol
        INPUT = {
          unicodemath: [["ee", "&#x2147;"], parsing_wrapper(["EE", "exi"])],
          asciimath: [["mathbb(e)", "&#x2147;"], parsing_wrapper(["ee"])],
          mathml: ["&#x2147;"],
          latex: [["\\mathbb{e}", "&#x2147;"], parsing_wrapper(["ee"])],
          omml: ["&#x2147;"],
          html: ["&#x2147;"],
        }.freeze

        # output methods
        def to_latex
          "\\mathbb{e}"
        end

        def to_asciimath
          "mathbb(e)"
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2147;")
        end

        def to_mathml_without_math_tag(intent)
          attributes = { intent: encoded } if intent
          ox_element("mi", attributes: attributes) << "&#x2147;"
        end

        def to_omml_without_math_tag(_)
          "&#x2147;"
        end

        def to_html
          "&#x2147;"
        end

        private

        def encoded
          Utility.html_entity_to_unicode("&#x2147;")
        end
      end
    end
  end
end
