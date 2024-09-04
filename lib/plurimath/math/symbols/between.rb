module Plurimath
  module Math
    module Symbols
      class Between < Symbol
        INPUT = {
          unicodemath: [["between", "&#x226c;"]],
          asciimath: [["&#x226c;"], parsing_wrapper(["between"], lang: :asciimath)],
          mathml: ["&#x226c;"],
          latex: [["between", "&#x226c;"]],
          omml: ["&#x226c;"],
          html: ["&#x226c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\between"
        end

        def to_asciimath(**)
          parsing_wrapper("between", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x226c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x226c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x226c;"
        end

        def to_html(**)
          "&#x226c;"
        end
      end
    end
  end
end
