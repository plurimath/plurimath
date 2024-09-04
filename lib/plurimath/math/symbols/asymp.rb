module Plurimath
  module Math
    module Symbols
      class Asymp < Symbol
        INPUT = {
          unicodemath: [["asymp", "&#x224d;"]],
          asciimath: [["&#x224d;"], parsing_wrapper(["asymp"], lang: :asciimath)],
          mathml: ["&#x224d;"],
          latex: [["asymp", "&#x224d;"]],
          omml: ["&#x224d;"],
          html: ["&#x224d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\asymp"
        end

        def to_asciimath(**)
          parsing_wrapper("asymp", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x224d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x224d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x224d;"
        end

        def to_html(**)
          "&#x224d;"
        end
      end
    end
  end
end
