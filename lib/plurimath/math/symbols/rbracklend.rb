module Plurimath
  module Math
    module Symbols
      class Rbracklend < Symbol
        INPUT = {
          unicodemath: [["&#x23a6;"], parsing_wrapper(["rbracklend"], lang: :unicode)],
          asciimath: [["&#x23a6;"], parsing_wrapper(["rbracklend"], lang: :asciimath)],
          mathml: ["&#x23a6;"],
          latex: [["rbracklend", "&#x23a6;"]],
          omml: ["&#x23a6;"],
          html: ["&#x23a6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rbracklend"
        end

        def to_asciimath(**)
          parsing_wrapper("rbracklend", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23a6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23a6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23a6;"
        end

        def to_html(**)
          "&#x23a6;"
        end
      end
    end
  end
end
