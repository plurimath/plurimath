module Plurimath
  module Math
    module Symbols
      class Ii < Symbol
        INPUT = {
          unicodemath: [["ii", "&#x2148;"], parsing_wrapper(["ComplexI"], lang: :unicode)],
          asciimath: [["&#x2148;"], parsing_wrapper(["ii", "ComplexI"], lang: :asciimath)],
          mathml: ["&#x2148;"],
          latex: [["ComplexI", "ii", "&#x2148;"]],
          omml: ["&#x2148;"],
          html: ["&#x2148;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ComplexI"
        end

        def to_asciimath(**)
          parsing_wrapper("ii", lang: :asciimath)
        end

        def to_unicodemath(**)
          encoded
        end

        def to_mathml_without_math_tag(intent, **)
          attributes = { intent: encoded } if intent
          ox_element("mi", attributes: attributes) << "&#x2148;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2148;"
        end

        def to_html(**)
          "&#x2148;"
        end

        def intent_names
          { name: encoded }
        end

        private

        def encoded
          Utility.html_entity_to_unicode("&#x2148;")
        end
      end
    end
  end
end
