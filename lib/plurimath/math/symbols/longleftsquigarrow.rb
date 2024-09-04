module Plurimath
  module Math
    module Symbols
      class Longleftsquigarrow < Symbol
        INPUT = {
          unicodemath: [["&#x2b33;"], parsing_wrapper(["longleftsquigarrow"], lang: :unicode)],
          asciimath: [["&#x2b33;"], parsing_wrapper(["longleftsquigarrow"], lang: :asciimath)],
          mathml: ["&#x2b33;"],
          latex: [["longleftsquigarrow", "&#x2b33;"]],
          omml: ["&#x2b33;"],
          html: ["&#x2b33;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\longleftsquigarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("longleftsquigarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b33;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b33;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b33;"
        end

        def to_html(**)
          "&#x2b33;"
        end
      end
    end
  end
end
