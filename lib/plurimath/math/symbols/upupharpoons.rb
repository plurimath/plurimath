module Plurimath
  module Math
    module Symbols
      class Upupharpoons < Symbol
        INPUT = {
          unicodemath: [["&#x2963;"], parsing_wrapper(["upharpoonsleftright", "upupharpoons"], lang: :unicode)],
          asciimath: [["&#x2963;"], parsing_wrapper(["upharpoonsleftright", "upupharpoons"], lang: :asciimath)],
          mathml: ["&#x2963;"],
          latex: [["upharpoonsleftright", "upupharpoons", "&#x2963;"]],
          omml: ["&#x2963;"],
          html: ["&#x2963;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\upharpoonsleftright"
        end

        def to_asciimath(**)
          parsing_wrapper("upupharpoons", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2963;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2963;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2963;"
        end

        def to_html(**)
          "&#x2963;"
        end
      end
    end
  end
end
