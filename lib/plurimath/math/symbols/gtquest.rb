module Plurimath
  module Math
    module Symbols
      class Gtquest < Symbol
        INPUT = {
          unicodemath: [["&#x2a7c;"], parsing_wrapper(["gtquest"], lang: :unicode)],
          asciimath: [["&#x2a7c;"], parsing_wrapper(["gtquest"], lang: :asciimath)],
          mathml: ["&#x2a7c;"],
          latex: [["gtquest", "&#x2a7c;"]],
          omml: ["&#x2a7c;"],
          html: ["&#x2a7c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\gtquest"
        end

        def to_asciimath(**)
          parsing_wrapper("gtquest", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a7c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a7c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a7c;"
        end

        def to_html(**)
          "&#x2a7c;"
        end
      end
    end
  end
end
