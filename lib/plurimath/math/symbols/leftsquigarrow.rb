module Plurimath
  module Math
    module Symbols
      class Leftsquigarrow < Symbol
        INPUT = {
          unicodemath: [["leftsquigarrow", "&#x21dc;"]],
          asciimath: [["&#x21dc;"], parsing_wrapper(["leftsquigarrow"], lang: :asciimath)],
          mathml: ["&#x21dc;"],
          latex: [["leftsquigarrow", "&#x21dc;"]],
          omml: ["&#x21dc;"],
          html: ["&#x21dc;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftsquigarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("leftsquigarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21dc;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21dc;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21dc;"
        end

        def to_html(**)
          "&#x21dc;"
        end
      end
    end
  end
end
