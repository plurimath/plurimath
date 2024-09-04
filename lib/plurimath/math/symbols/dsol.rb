module Plurimath
  module Math
    module Symbols
      class Dsol < Symbol
        INPUT = {
          unicodemath: [["&#x29f6;"], parsing_wrapper(["dsol"], lang: :unicode)],
          asciimath: [["&#x29f6;"], parsing_wrapper(["dsol"], lang: :asciimath)],
          mathml: ["&#x29f6;"],
          latex: [["dsol", "&#x29f6;"]],
          omml: ["&#x29f6;"],
          html: ["&#x29f6;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\dsol"
        end

        def to_asciimath(**)
          parsing_wrapper("dsol", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x29f6;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x29f6;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x29f6;"
        end

        def to_html(**)
          "&#x29f6;"
        end
      end
    end
  end
end
