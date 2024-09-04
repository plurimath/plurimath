module Plurimath
  module Math
    module Symbols
      class Imageof < Symbol
        INPUT = {
          unicodemath: [["&#x22b7;"], parsing_wrapper(["multimapdotbothB", "imageof"], lang: :unicode)],
          asciimath: [["&#x22b7;"], parsing_wrapper(["multimapdotbothB", "imageof"], lang: :asciimath)],
          mathml: ["&#x22b7;"],
          latex: [["multimapdotbothB", "imageof", "&#x22b7;"]],
          omml: ["&#x22b7;"],
          html: ["&#x22b7;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\multimapdotbothB"
        end

        def to_asciimath(**)
          parsing_wrapper("imageof", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22b7;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22b7;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22b7;"
        end

        def to_html(**)
          "&#x22b7;"
        end
      end
    end
  end
end
