module Plurimath
  module Math
    module Symbols
      class Bar < Symbol
        INPUT = {
          unicodemath: [["¯"]],
          asciimath: [["¯"]],
          mathml: ["¯"],
          latex: [["¯"]],
          omml: ["¯"],
          html: ["¯"],
        }.freeze

        # output methods
        def to_latex
          parsing_wrapper("bar")
        end

        def to_asciimath
          parsing_wrapper("bar")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("¯")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "¯"
        end

        def to_omml_without_math_tag(_)
          "¯"
        end

        def to_html
          "¯"
        end
      end
    end
  end
end
