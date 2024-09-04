module Plurimath
  module Math
    module Symbols
      class Lbraceuend < Symbol
        INPUT = {
          unicodemath: [["&#x23a7;"], parsing_wrapper(["lbraceuend"], lang: :unicode)],
          asciimath: [["&#x23a7;"], parsing_wrapper(["lbraceuend"], lang: :asciimath)],
          mathml: ["&#x23a7;"],
          latex: [["lbraceuend", "&#x23a7;"]],
          omml: ["&#x23a7;"],
          html: ["&#x23a7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lbraceuend"
        end

        def to_asciimath(**)
          parsing_wrapper("lbraceuend", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23a7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23a7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23a7;"
        end

        def to_html(**)
          "&#x23a7;"
        end
      end
    end
  end
end
