module Plurimath
  module Math
    module Symbols
      class Annuity < Symbol
        INPUT = {
          unicodemath: [["&#x20e7;"], parsing_wrapper(["annuity"], lang: :unicode)],
          asciimath: [["&#x20e7;"], parsing_wrapper(["annuity"], lang: :asciimath)],
          mathml: ["&#x20e7;"],
          latex: [["annuity", "&#x20e7;"]],
          omml: ["&#x20e7;"],
          html: ["&#x20e7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\annuity"
        end

        def to_asciimath(**)
          parsing_wrapper("annuity", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x20e7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x20e7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x20e7;"
        end

        def to_html(**)
          "&#x20e7;"
        end
      end
    end
  end
end
