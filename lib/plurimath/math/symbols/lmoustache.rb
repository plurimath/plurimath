module Plurimath
  module Math
    module Symbols
      class Lmoustache < Symbol
        INPUT = {
          unicodemath: [["&#x23b0;"], parsing_wrapper(["lmoustache"], lang: :unicode)],
          asciimath: [["&#x23b0;"], parsing_wrapper(["lmoustache"], lang: :asciimath)],
          mathml: ["&#x23b0;"],
          latex: [["lmoustache", "&#x23b0;"]],
          omml: ["&#x23b0;"],
          html: ["&#x23b0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\lmoustache"
        end

        def to_asciimath(**)
          parsing_wrapper("lmoustache", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23b0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23b0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23b0;"
        end

        def to_html(**)
          "&#x23b0;"
        end
      end
    end
  end
end
