module Plurimath
  module Math
    module Symbols
      class Checkmark < Symbol
        INPUT = {
          unicodemath: [["&#x2713;"], parsing_wrapper(["ballotcheck", "checkmark"], lang: :unicode)],
          asciimath: [["&#x2713;"], parsing_wrapper(["ballotcheck", "checkmark"], lang: :asciimath)],
          mathml: ["&#x2713;"],
          latex: [["ballotcheck", "checkmark", "&#x2713;"]],
          omml: ["&#x2713;"],
          html: ["&#x2713;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ballotcheck"
        end

        def to_asciimath(**)
          parsing_wrapper("checkmark", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2713;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2713;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2713;"
        end

        def to_html(**)
          "&#x2713;"
        end
      end
    end
  end
end
