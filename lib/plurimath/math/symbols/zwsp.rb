module Plurimath
  module Math
    module Symbols
      class Zwsp < Symbol
        INPUT = {
          unicodemath: [["zwsp", "&#x200b;"]],
          asciimath: [["&#x200b;"], parsing_wrapper(["zwsp"], lang: :asciimath)],
          mathml: ["&#x200b;"],
          latex: [["&#x200b;"], parsing_wrapper(["zwsp"], lang: :latex)],
          omml: ["&#x200b;"],
          html: ["&#x200b;"],
        }.freeze

        # output methods
        def to_latex(**)
          parsing_wrapper("zwsp", lang: :latex)
        end

        def to_asciimath(**)
          parsing_wrapper("zwsp", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x200b;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x200b;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x200b;"
        end

        def to_html(**)
          "&#x200b;"
        end
      end
    end
  end
end
