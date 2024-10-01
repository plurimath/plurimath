module Plurimath
  module Math
    module Symbols
      class Intercal < Symbol
        INPUT = {
          unicodemath: [["intercal", "&#x22ba;"]],
          asciimath: [["&#x22ba;"], parsing_wrapper(["intercal"], lang: :asciimath)],
          mathml: ["&#x22ba;"],
          latex: [["intercal", "&#x22ba;"]],
          omml: ["&#x22ba;"],
          html: ["&#x22ba;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\intercal"
        end

        def to_asciimath(**)
          parsing_wrapper("intercal", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22ba;")
        end

        def to_mathml_without_math_tag(intent, **)
          attribute = { intent: "transpose" } if intent
          ox_element("mi", attributes: attribute) << "&#x22ba;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22ba;"
        end

        def to_html(**)
          "&#x22ba;"
        end

        def intent_names
          { name: "transpose" }
        end
      end
    end
  end
end
