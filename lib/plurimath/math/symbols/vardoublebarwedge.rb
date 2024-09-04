module Plurimath
  module Math
    module Symbols
      class Vardoublebarwedge < Symbol
        INPUT = {
          unicodemath: [["&#x2306;"], parsing_wrapper(["vardoublebarwedge"], lang: :unicode)],
          asciimath: [["&#x2306;"], parsing_wrapper(["vardoublebarwedge"], lang: :asciimath)],
          mathml: ["&#x2306;"],
          latex: [["vardoublebarwedge", "&#x2306;"]],
          omml: ["&#x2306;"],
          html: ["&#x2306;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\vardoublebarwedge"
        end

        def to_asciimath(**)
          parsing_wrapper("vardoublebarwedge", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2306;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2306;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2306;"
        end

        def to_html(**)
          "&#x2306;"
        end
      end
    end
  end
end
