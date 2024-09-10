module Plurimath
  module Math
    module Symbols
      class Twocups < Symbol
        INPUT = {
          unicodemath: [["&#x2a4a;"], parsing_wrapper(["twocups"], lang: :unicode)],
          asciimath: [["&#x2a4a;"], parsing_wrapper(["twocups"], lang: :asciimath)],
          mathml: ["&#x2a4a;"],
          latex: [["twocups", "&#x2a4a;"]],
          omml: ["&#x2a4a;"],
          html: ["&#x2a4a;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\twocups"
        end

        def to_asciimath(**)
          parsing_wrapper("twocups", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2a4a;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2a4a;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2a4a;"
        end

        def to_html(**)
          "&#x2a4a;"
        end

        def to_html(**)
          "&#x2a4a;"
        end
      end
    end
  end
end
