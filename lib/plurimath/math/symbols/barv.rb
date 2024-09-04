module Plurimath
  module Math
    module Symbols
      class Barv < Symbol
        INPUT = {
          unicodemath: [["&#x2ae7;"], parsing_wrapper(["Barv"], lang: :unicode)],
          asciimath: [["&#x2ae7;"], parsing_wrapper(["Barv"], lang: :asciimath)],
          mathml: ["&#x2ae7;"],
          latex: [["Barv", "&#x2ae7;"]],
          omml: ["&#x2ae7;"],
          html: ["&#x2ae7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\Barv"
        end

        def to_asciimath(**)
          parsing_wrapper("Barv", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2ae7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2ae7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2ae7;"
        end

        def to_html(**)
          "&#x2ae7;"
        end
      end
    end
  end
end
