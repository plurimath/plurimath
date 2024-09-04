module Plurimath
  module Math
    module Symbols
      class Veebar < Symbol
        INPUT = {
          unicodemath: [["&#x22bb;"], parsing_wrapper(["veebar"], lang: :unicode)],
          asciimath: [["&#x22bb;"], parsing_wrapper(["veebar"], lang: :asciimath)],
          mathml: ["&#x22bb;"],
          latex: [["veebar", "&#x22bb;"]],
          omml: ["&#x22bb;"],
          html: ["&#x22bb;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\veebar"
        end

        def to_asciimath(**)
          parsing_wrapper("veebar", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22bb;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22bb;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22bb;"
        end

        def to_html(**)
          "&#x22bb;"
        end
      end
    end
  end
end
