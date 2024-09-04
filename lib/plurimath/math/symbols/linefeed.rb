module Plurimath
  module Math
    module Symbols
      class Linefeed < Symbol
        INPUT = {
          unicodemath: [["&#x21b4;"], parsing_wrapper(["linefeed"], lang: :unicode)],
          asciimath: [["&#x21b4;"], parsing_wrapper(["linefeed"], lang: :asciimath)],
          mathml: ["&#x21b4;"],
          latex: [["linefeed", "&#x21b4;"]],
          omml: ["&#x21b4;"],
          html: ["&#x21b4;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\linefeed"
        end

        def to_asciimath(**)
          parsing_wrapper("linefeed", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x21b4;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x21b4;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x21b4;"
        end

        def to_html(**)
          "&#x21b4;"
        end
      end
    end
  end
end
