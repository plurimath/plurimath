module Plurimath
  module Math
    module Symbols
      class Dd < Symbol
        INPUT = {
          unicodemath: [["dd", "&#x2146;"], parsing_wrapper(["DifferentialD"], lang: :unicode)],
          asciimath: [["&#x2146;"], parsing_wrapper(["dd", "DifferentialD"], lang: :asciimath)],
          mathml: ["&#x2146;"],
          latex: [["DifferentialD", "dd", "&#x2146;"]],
          omml: ["&#x2146;"],
          html: ["&#x2146;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\DifferentialD"
        end

        def to_asciimath(**)
          parsing_wrapper("dd", lang: :asciimath)
        end

        def to_unicodemath(**)
          encoded
        end

        def to_mathml_without_math_tag(intent, **)
          attributes = { intent: encoded } if intent
          ox_element("mi", attributes: attributes) << "&#x2146;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2146;"
        end

        def to_html(**)
          "&#x2146;"
        end

        def intent_names
          { name: encoded }
        end

        private

        def encoded
          Utility.html_entity_to_unicode("&#x2146;")
        end
      end
    end
  end
end
