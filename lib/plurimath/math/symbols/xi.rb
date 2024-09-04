module Plurimath
  module Math
    module Symbols
      class Xi < Symbol
        INPUT = {
          unicodemath: [["xi", "&#x3be;"], parsing_wrapper(["upxi"], lang: :unicode)],
          asciimath: [["xi", "&#x3be;"], parsing_wrapper(["upxi"], lang: :asciimath)],
          mathml: ["&#x3be;"],
          latex: [["upxi", "xi", "&#x3be;"]],
          omml: ["&#x3be;"],
          html: ["&#x3be;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\xi"
        end

        def to_asciimath(**)
          "xi"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x3be;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x3be;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x3be;"
        end

        def to_html(**)
          "&#x3be;"
        end
      end
    end
  end
end
