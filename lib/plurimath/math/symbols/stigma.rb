module Plurimath
  module Math
    module Symbols
      class Stigma < Symbol
        INPUT = {
          unicodemath: [["&#x3db;"], parsing_wrapper(["upstigma", "stigma"], lang: :unicode)],
          asciimath: [["&#x3db;"], parsing_wrapper(["upstigma", "stigma"], lang: :asciimath)],
          mathml: ["&#x3db;"],
          latex: [["upstigma", "stigma", "&#x3db;"]],
          omml: ["&#x3db;"],
          html: ["&#x3db;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upstigma"
        end

        def to_asciimath(**)
          parsing_wrapper("stigma", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3db;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3db;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3db;"
        end

        def to_html(**)
          "&#x3db;"
        end
      end
    end
  end
end
