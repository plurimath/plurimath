module Plurimath
  module Math
    module Symbols
      class Strictfi < Symbol
        INPUT = {
          unicodemath: [["&#x297c;"], parsing_wrapper(["leftfishtail", "strictfi"], lang: :unicode)],
          asciimath: [["&#x297c;"], parsing_wrapper(["leftfishtail", "strictfi"], lang: :asciimath)],
          mathml: ["&#x297c;"],
          latex: [["leftfishtail", "strictfi", "&#x297c;"]],
          omml: ["&#x297c;"],
          html: ["&#x297c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftfishtail"
        end

        def to_asciimath(**)
          parsing_wrapper("strictfi", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x297c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x297c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x297c;"
        end

        def to_html(**)
          "&#x297c;"
        end
      end
    end
  end
end
