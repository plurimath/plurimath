module Plurimath
  module Math
    module Symbols
      class Multimap < Symbol
        INPUT = {
          unicodemath: [["multimap", "&#x22b8;"]],
          asciimath: [["&#x22b8;"], parsing_wrapper(["multimap"], lang: :asciimath)],
          mathml: ["&#x22b8;"],
          latex: [["multimap", "&#x22b8;"]],
          omml: ["&#x22b8;"],
          html: ["&#x22b8;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\multimap"
        end

        def to_asciimath(**)
          parsing_wrapper("multimap", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22b8;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22b8;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22b8;"
        end

        def to_html(**)
          "&#x22b8;"
        end
      end
    end
  end
end
