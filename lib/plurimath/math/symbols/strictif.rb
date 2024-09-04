module Plurimath
  module Math
    module Symbols
      class Strictif < Symbol
        INPUT = {
          unicodemath: [["&#x297d;"], parsing_wrapper(["rightfishtail", "strictif"], lang: :unicode)],
          asciimath: [["&#x297d;"], parsing_wrapper(["rightfishtail", "strictif"], lang: :asciimath)],
          mathml: ["&#x297d;"],
          latex: [["rightfishtail", "strictif", "&#x297d;"]],
          omml: ["&#x297d;"],
          html: ["&#x297d;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightfishtail"
        end

        def to_asciimath(**)
          parsing_wrapper("strictif", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x297d;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x297d;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x297d;"
        end

        def to_html(**)
          "&#x297d;"
        end
      end
    end
  end
end
