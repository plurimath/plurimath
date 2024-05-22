module Plurimath
  module Math
    module Symbols
      class Dashvdash < Symbol
        INPUT = {
          unicodemath: [["&#x27db;"], parsing_wrapper(["dashVdash"])],
          asciimath: [["&#x27db;"], parsing_wrapper(["dashVdash"])],
          mathml: ["&#x27db;"],
          latex: [["dashVdash", "&#x27db;"]],
          omml: ["&#x27db;"],
          html: ["&#x27db;"],
        }.freeze

        # output methods
        def to_latex
          "\\dashVdash"
        end

        def to_asciimath
          parsing_wrapper("dashVdash")
        end

        def to_unicodemath
          Utility.html_entity_to_unicode("&#x27db;")
        end

        def to_mathml_without_math_tag(_)
          ox_element("mi") << "&#x27db;"
        end

        def to_omml_without_math_tag(_)
          "&#x27db;"
        end

        def to_html
          "&#x27db;"
        end
      end
    end
  end
end
