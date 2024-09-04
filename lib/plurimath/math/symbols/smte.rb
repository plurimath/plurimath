module Plurimath
  module Math
    module Symbols
      class Smte < Symbol
        INPUT = {
          unicodemath: [["&#x2aac;"], parsing_wrapper(["smte"], lang: :unicode)],
          asciimath: [["&#x2aac;"], parsing_wrapper(["smte"], lang: :asciimath)],
          mathml: ["&#x2aac;"],
          latex: [["smte", "&#x2aac;"]],
          omml: ["&#x2aac;"],
          html: ["&#x2aac;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\smte"
        end

        def to_asciimath(**)
          parsing_wrapper("smte", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2aac;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2aac;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2aac;"
        end

        def to_html(**)
          "&#x2aac;"
        end
      end
    end
  end
end
