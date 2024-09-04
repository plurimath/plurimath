module Plurimath
  module Math
    module Symbols
      class Rbrackurtick < Symbol
        INPUT = {
          unicodemath: [["&#x2990;"], parsing_wrapper(["rbrackurtick"], lang: :unicode)],
          asciimath: [["&#x2990;"], parsing_wrapper(["rbrackurtick"], lang: :asciimath)],
          mathml: ["&#x2990;"],
          latex: [["rbrackurtick", "&#x2990;"]],
          omml: ["&#x2990;"],
          html: ["&#x2990;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rbrackurtick"
        end

        def to_asciimath(**)
          parsing_wrapper("rbrackurtick", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2990;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2990;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2990;"
        end

        def to_html(**)
          "&#x2990;"
        end
      end
    end
  end
end
