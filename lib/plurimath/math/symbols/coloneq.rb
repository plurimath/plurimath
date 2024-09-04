module Plurimath
  module Math
    module Symbols
      class Coloneq < Symbol
        INPUT = {
          unicodemath: [["&#x2a74;"], parsing_wrapper(["Coloneqq", "Coloneq"], lang: :unicode)],
          asciimath: [["&#x2a74;"], parsing_wrapper(["Coloneqq", "Coloneq"], lang: :asciimath)],
          mathml: ["&#x2a74;"],
          latex: [["Coloneqq", "Coloneq", "&#x2a74;"]],
          omml: ["&#x2a74;"],
          html: ["&#x2a74;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Coloneqq"
        end

        def to_asciimath(**)
          parsing_wrapper("Coloneq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a74;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a74;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a74;"
        end

        def to_html(**)
          "&#x2a74;"
        end
      end
    end
  end
end
