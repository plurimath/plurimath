module Plurimath
  module Math
    module Symbols
      class Nsucceq < Symbol
        INPUT = {
          unicodemath: [["nsucccurlyeq", "&#x22e1;"], parsing_wrapper(["nsucceq"], lang: :unicode)],
          asciimath: [["&#x22e1;"], parsing_wrapper(["nsucccurlyeq", "nsucceq"], lang: :asciimath)],
          mathml: ["&#x22e1;"],
          latex: [["nsucccurlyeq", "nsucceq", "&#x22e1;"]],
          omml: ["&#x22e1;"],
          html: ["&#x22e1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\nsucccurlyeq"
        end

        def to_asciimath(**)
          parsing_wrapper("nsucceq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22e1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22e1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22e1;"
        end

        def to_html(**)
          "&#x22e1;"
        end
      end
    end
  end
end
