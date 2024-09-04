module Plurimath
  module Math
    module Symbols
      class Shortuptack < Symbol
        INPUT = {
          unicodemath: [["&#x2ae0;"], parsing_wrapper(["shortuptack"], lang: :unicode)],
          asciimath: [["&#x2ae0;"], parsing_wrapper(["shortuptack"], lang: :asciimath)],
          mathml: ["&#x2ae0;"],
          latex: [["shortuptack", "&#x2ae0;"]],
          omml: ["&#x2ae0;"],
          html: ["&#x2ae0;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\shortuptack"
        end

        def to_asciimath(**)
          parsing_wrapper("shortuptack", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ae0;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ae0;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ae0;"
        end

        def to_html(**)
          "&#x2ae0;"
        end
      end
    end
  end
end
