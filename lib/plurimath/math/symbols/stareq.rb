module Plurimath
  module Math
    module Symbols
      class Stareq < Symbol
        INPUT = {
          unicodemath: [["&#x225b;"], parsing_wrapper(["stareq"], lang: :unicode)],
          asciimath: [["&#x225b;"], parsing_wrapper(["stareq"], lang: :asciimath)],
          mathml: ["&#x225b;"],
          latex: [["stareq", "&#x225b;"]],
          omml: ["&#x225b;"],
          html: ["&#x225b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\stareq"
        end

        def to_asciimath(**)
          parsing_wrapper("stareq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x225b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x225b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x225b;"
        end

        def to_html(**)
          "&#x225b;"
        end
      end
    end
  end
end
