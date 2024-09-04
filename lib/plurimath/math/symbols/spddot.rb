module Plurimath
  module Math
    module Symbols
      class Spddot < Symbol
        INPUT = {
          unicodemath: [["&#xa8;"], parsing_wrapper(["spddot"], lang: :unicode)],
          asciimath: [["&#xa8;"], parsing_wrapper(["spddot"], lang: :asciimath)],
          mathml: ["&#xa8;"],
          latex: [["spddot", "&#xa8;"]],
          omml: ["&#xa8;"],
          html: ["&#xa8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\spddot"
        end

        def to_asciimath(**)
          parsing_wrapper("spddot", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#xa8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#xa8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#xa8;"
        end

        def to_html(**)
          "&#xa8;"
        end
      end
    end
  end
end
