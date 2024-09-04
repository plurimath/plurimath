module Plurimath
  module Math
    module Symbols
      class Tcmu < Symbol
        INPUT = {
          unicodemath: [["&#xb5;"], parsing_wrapper(["Micro", "tcmu"], lang: :unicode)],
          asciimath: [["&#xb5;"], parsing_wrapper(["Micro", "tcmu"], lang: :asciimath)],
          mathml: ["&#xb5;"],
          latex: [["Micro", "tcmu", "&#xb5;"]],
          omml: ["&#xb5;"],
          html: ["&#xb5;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Micro"
        end

        def to_asciimath(**)
          parsing_wrapper("tcmu", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#xb5;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#xb5;"
        end

        def to_omml_without_math_tag(_, **)
          "&#xb5;"
        end

        def to_html(**)
          "&#xb5;"
        end
      end
    end
  end
end
