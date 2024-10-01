module Plurimath
  module Math
    module Symbols
      class Jj < Symbol
        INPUT = {
          unicodemath: [["jj", "&#x2149;"], parsing_wrapper(["ComplexJ"], lang: :unicode)],
          asciimath: [["&#x2149;"], parsing_wrapper(["jj", "ComplexJ"], lang: :asciimath)],
          mathml: ["&#x2149;"],
          latex: [["ComplexJ", "jj", "&#x2149;"]],
          omml: ["&#x2149;"],
          html: ["&#x2149;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ComplexJ"
        end

        def to_asciimath(**)
          parsing_wrapper("jj", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2149;")
        end

        def to_mathml_without_math_tag(intent, **)
          attributes = { intent: encoded } if intent
          ox_element("mi", attributes: attributes) << "&#x2149;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2149;"
        end

        def to_html(**)
          "&#x2149;"
        end

        def intent_names
          { name: encoded }
        end

        private

        def encoded
          Utility.html_entity_to_unicode("&#x2149;")
        end
      end
    end
  end
end
