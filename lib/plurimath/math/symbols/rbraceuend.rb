module Plurimath
  module Math
    module Symbols
      class Rbraceuend < Symbol
        INPUT = {
          unicodemath: [["&#x23ab;"], parsing_wrapper(["rbraceuend"], lang: :unicode)],
          asciimath: [["&#x23ab;"], parsing_wrapper(["rbraceuend"], lang: :asciimath)],
          mathml: ["&#x23ab;"],
          latex: [["rbraceuend", "&#x23ab;"]],
          omml: ["&#x23ab;"],
          html: ["&#x23ab;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rbraceuend"
        end

        def to_asciimath(**)
          parsing_wrapper("rbraceuend", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23ab;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23ab;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23ab;"
        end

        def to_html(**)
          "&#x23ab;"
        end
      end
    end
  end
end
