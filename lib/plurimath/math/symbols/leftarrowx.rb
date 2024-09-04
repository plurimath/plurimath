module Plurimath
  module Math
    module Symbols
      class Leftarrowx < Symbol
        INPUT = {
          unicodemath: [["&#x2b3e;"], parsing_wrapper(["leftarrowx"], lang: :unicode)],
          asciimath: [["&#x2b3e;"], parsing_wrapper(["leftarrowx"], lang: :asciimath)],
          mathml: ["&#x2b3e;"],
          latex: [["leftarrowx", "&#x2b3e;"]],
          omml: ["&#x2b3e;"],
          html: ["&#x2b3e;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftarrowx"
        end

        def to_asciimath(**)
          parsing_wrapper("leftarrowx", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2b3e;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2b3e;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2b3e;"
        end

        def to_html(**)
          "&#x2b3e;"
        end
      end
    end
  end
end
