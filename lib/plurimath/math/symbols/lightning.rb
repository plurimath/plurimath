module Plurimath
  module Math
    module Symbols
      class Lightning < Symbol
        INPUT = {
          unicodemath: [["&#x21af;"], parsing_wrapper(["downzigzagarrow", "lightning"], lang: :unicode)],
          asciimath: [["&#x21af;"], parsing_wrapper(["downzigzagarrow", "lightning"], lang: :asciimath)],
          mathml: ["&#x21af;"],
          latex: [["downzigzagarrow", "lightning", "&#x21af;"]],
          omml: ["&#x21af;"],
          html: ["&#x21af;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\downzigzagarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("lightning", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21af;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21af;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21af;"
        end

        def to_html(**)
          "&#x21af;"
        end
      end
    end
  end
end
