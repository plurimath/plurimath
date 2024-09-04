module Plurimath
  module Math
    module Symbols
      class Ltquest < Symbol
        INPUT = {
          unicodemath: [["&#x2a7b;"], parsing_wrapper(["ltquest"], lang: :unicode)],
          asciimath: [["&#x2a7b;"], parsing_wrapper(["ltquest"], lang: :asciimath)],
          mathml: ["&#x2a7b;"],
          latex: [["ltquest", "&#x2a7b;"]],
          omml: ["&#x2a7b;"],
          html: ["&#x2a7b;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\ltquest"
        end

        def to_asciimath(**)
          parsing_wrapper("ltquest", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a7b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a7b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a7b;"
        end

        def to_html(**)
          "&#x2a7b;"
        end
      end
    end
  end
end
