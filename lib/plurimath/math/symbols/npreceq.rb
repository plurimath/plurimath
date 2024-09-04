module Plurimath
  module Math
    module Symbols
      class Npreceq < Symbol
        INPUT = {
          unicodemath: [["npreccurlyeq", "&#x22e0;"], parsing_wrapper(["npreceq"], lang: :unicode)],
          asciimath: [["&#x22e0;"], parsing_wrapper(["npreccurlyeq", "npreceq"], lang: :asciimath)],
          mathml: ["&#x22e0;"],
          latex: [["npreccurlyeq", "npreceq", "&#x22e0;"]],
          omml: ["&#x22e0;"],
          html: ["&#x22e0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\npreccurlyeq"
        end

        def to_asciimath(**)
          parsing_wrapper("npreceq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22e0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22e0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22e0;"
        end

        def to_html(**)
          "&#x22e0;"
        end
      end
    end
  end
end
