module Plurimath
  module Math
    module Symbols
      class Circlellquad < Symbol
        INPUT = {
          unicodemath: [["&#x25f5;"], parsing_wrapper(["circlellquad"], lang: :unicode)],
          asciimath: [["&#x25f5;"], parsing_wrapper(["circlellquad"], lang: :asciimath)],
          mathml: ["&#x25f5;"],
          latex: [["circlellquad", "&#x25f5;"]],
          omml: ["&#x25f5;"],
          html: ["&#x25f5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\circlellquad"
        end

        def to_asciimath(**)
          parsing_wrapper("circlellquad", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25f5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25f5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25f5;"
        end

        def to_html(**)
          "&#x25f5;"
        end
      end
    end
  end
end
