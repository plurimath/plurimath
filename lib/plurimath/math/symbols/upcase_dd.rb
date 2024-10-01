module Plurimath
  module Math
    module Symbols
      class UpcaseDd < Symbol
        INPUT = {
          unicodemath: ["Dd", "&#x2145;"],
          asciimath: [["&#x2145;"], parsing_wrapper(["Dd"], lang: :asciimath)],
          mathml: ["&#x2145;"],
          latex: ["&#x2145;", parsing_wrapper(["Dd"], lang: :latex)],
          omml: ["&#x2145;"],
          html: ["&#x2145;"],
        }.freeze

        # output methods
        def to_latex(**)
          parsing_wrapper("Dd", lang: :latex)
        end

        def to_asciimath(**)
          parsing_wrapper("Dd", lang: :asciimath)
        end

        def to_unicodemath(**)
          encoded
        end

        def to_mathml_without_math_tag(intent, **)
          attributes = { intent: encoded } if intent
          ox_element("mi", attributes: attributes) << "&#x2145;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2145;"
        end

        def to_html(**)
          "&#x2145;"
        end

        def intent_names
          { name: encoded }
        end

        private

        def encoded
          Utility.html_entity_to_unicode("&#x2145;")
        end
      end
    end
  end
end
