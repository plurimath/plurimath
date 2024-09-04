module Plurimath
  module Math
    module Symbols
      class Lbracklend < Symbol
        INPUT = {
          unicodemath: [["&#x23a3;"], parsing_wrapper(["lbracklend"], lang: :unicode)],
          asciimath: [["&#x23a3;"], parsing_wrapper(["lbracklend"], lang: :asciimath)],
          mathml: ["&#x23a3;"],
          latex: [["lbracklend", "&#x23a3;"]],
          omml: ["&#x23a3;"],
          html: ["&#x23a3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lbracklend"
        end

        def to_asciimath(**)
          parsing_wrapper("lbracklend", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23a3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23a3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23a3;"
        end

        def to_html(**)
          "&#x23a3;"
        end
      end
    end
  end
end
