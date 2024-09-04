module Plurimath
  module Math
    module Symbols
      class Updasharrow < Symbol
        INPUT = {
          unicodemath: [["&#x21e1;"], parsing_wrapper(["updasharrow"], lang: :unicode)],
          asciimath: [["&#x21e1;"], parsing_wrapper(["updasharrow"], lang: :asciimath)],
          mathml: ["&#x21e1;"],
          latex: [["updasharrow", "&#x21e1;"]],
          omml: ["&#x21e1;"],
          html: ["&#x21e1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\updasharrow"
        end

        def to_asciimath(**)
          parsing_wrapper("updasharrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21e1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21e1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21e1;"
        end

        def to_html(**)
          "&#x21e1;"
        end
      end
    end
  end
end
