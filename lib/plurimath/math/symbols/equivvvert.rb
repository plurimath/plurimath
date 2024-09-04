module Plurimath
  module Math
    module Symbols
      class Equivvvert < Symbol
        INPUT = {
          unicodemath: [["&#x2a69;"], parsing_wrapper(["equivVvert"], lang: :unicode)],
          asciimath: [["&#x2a69;"], parsing_wrapper(["equivVvert"], lang: :asciimath)],
          mathml: ["&#x2a69;"],
          latex: [["equivVvert", "&#x2a69;"]],
          omml: ["&#x2a69;"],
          html: ["&#x2a69;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\equivVvert"
        end

        def to_asciimath(**)
          parsing_wrapper("equivVvert", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a69;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a69;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a69;"
        end

        def to_html(**)
          "&#x2a69;"
        end
      end
    end
  end
end
