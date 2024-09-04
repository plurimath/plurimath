module Plurimath
  module Math
    module Symbols
      class Circleurquad < Symbol
        INPUT = {
          unicodemath: [["&#x25f7;"], parsing_wrapper(["circleurquad"], lang: :unicode)],
          asciimath: [["&#x25f7;"], parsing_wrapper(["circleurquad"], lang: :asciimath)],
          mathml: ["&#x25f7;"],
          latex: [["circleurquad", "&#x25f7;"]],
          omml: ["&#x25f7;"],
          html: ["&#x25f7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circleurquad"
        end

        def to_asciimath(**)
          parsing_wrapper("circleurquad", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25f7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25f7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25f7;"
        end

        def to_html(**)
          "&#x25f7;"
        end
      end
    end
  end
end
