module Plurimath
  module Math
    module Symbols
      class Leftharpoonup < Symbol
        INPUT = {
          unicodemath: [["leftharpoonup", "&#x21bc;"]],
          asciimath: [["&#x21bc;"], parsing_wrapper(["leftharpoonup"], lang: :asciimath)],
          mathml: ["&#x21bc;"],
          latex: [["leftharpoonup", "&#x21bc;"]],
          omml: ["&#x21bc;"],
          html: ["&#x21bc;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftharpoonup"
        end

        def to_asciimath(**)
          parsing_wrapper("leftharpoonup", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21bc;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21bc;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21bc;"
        end

        def to_html(**)
          "&#x21bc;"
        end
      end
    end
  end
end
