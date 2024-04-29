module Plurimath
  module Math
    module Symbols
      class Neptune < Symbol
        INPUT = {
          unicodemath: [["&#x2646;"], parsing_wrapper(["neptune", "Neptune"])],
          asciimath: [["&#x2646;"], parsing_wrapper(["neptune", "Neptune"])],
          mathml: ["&#x2646;"],
          latex: [["neptune", "Neptune", "&#x2646;"]],
          omml: ["&#x2646;"],
          html: ["&#x2646;"],
        }.freeze

        # output methods
        def to_latex
          "\\neptune"
        end

        def to_asciimath
          parsing_wrapper("Neptune")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x2646;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x2646;"
        end

        def to_omml_without_math_tag(_)
          "&#x2646;"
        end

        def to_html
          "&#x2646;"
        end
      end
    end
  end
end
