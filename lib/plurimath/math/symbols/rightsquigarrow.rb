module Plurimath
  module Math
    module Symbols
      class Rightsquigarrow < Symbol
        INPUT = {
          unicodemath: [["rightsquigarrow", "&#x21dd;"]],
          asciimath: [["&#x21dd;"], parsing_wrapper(["rightsquigarrow"], lang: :asciimath)],
          mathml: ["&#x21dd;"],
          latex: [["rightsquigarrow", "&#x21dd;"]],
          omml: ["&#x21dd;"],
          html: ["&#x21dd;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rightsquigarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("rightsquigarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21dd;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21dd;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21dd;"
        end

        def to_html(**)
          "&#x21dd;"
        end
      end
    end
  end
end
