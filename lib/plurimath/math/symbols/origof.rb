module Plurimath
  module Math
    module Symbols
      class Origof < Symbol
        INPUT = {
          unicodemath: [["&#x22b6;"], parsing_wrapper(["multimapdotbothA", "origof"], lang: :unicode)],
          asciimath: [["&#x22b6;"], parsing_wrapper(["multimapdotbothA", "origof"], lang: :asciimath)],
          mathml: ["&#x22b6;"],
          latex: [["multimapdotbothA", "origof", "&#x22b6;"]],
          omml: ["&#x22b6;"],
          html: ["&#x22b6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\multimapdotbothA"
        end

        def to_asciimath(**)
          parsing_wrapper("origof", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22b6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22b6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22b6;"
        end

        def to_html(**)
          "&#x22b6;"
        end
      end
    end
  end
end
