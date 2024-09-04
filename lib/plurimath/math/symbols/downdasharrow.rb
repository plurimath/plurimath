module Plurimath
  module Math
    module Symbols
      class Downdasharrow < Symbol
        INPUT = {
          unicodemath: [["&#x21e3;"], parsing_wrapper(["downdasharrow"], lang: :unicode)],
          asciimath: [["&#x21e3;"], parsing_wrapper(["downdasharrow"], lang: :asciimath)],
          mathml: ["&#x21e3;"],
          latex: [["downdasharrow", "&#x21e3;"]],
          omml: ["&#x21e3;"],
          html: ["&#x21e3;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\downdasharrow"
        end

        def to_asciimath(**)
          parsing_wrapper("downdasharrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21e3;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21e3;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21e3;"
        end

        def to_html(**)
          "&#x21e3;"
        end
      end
    end
  end
end
