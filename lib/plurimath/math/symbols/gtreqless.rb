module Plurimath
  module Math
    module Symbols
      class Gtreqless < Symbol
        INPUT = {
          unicodemath: [["gtreqless", "&#x22db;"]],
          asciimath: [["&#x22db;"], parsing_wrapper(["gtreqless"])],
          mathml: ["&#x22db;"],
          latex: [["gtreqless", "&#x22db;"]],
          omml: ["&#x22db;"],
          html: ["&#x22db;"],
        }.freeze

        # output methods
        def to_latex
          "\\gtreqless"
        end

        def to_asciimath
          parsing_wrapper("gtreqless")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x22db;")
        end

        def to_mathml_without_math_tag
          ox_element("mi") << "&#x22db;"
        end

        def to_omml_without_math_tag(_)
          "&#x22db;"
        end

        def to_html
          "&#x22db;"
        end
      end
    end
  end
end
