module Plurimath
  module Math
    module Symbols
      class Blockhalfshaded < Symbol
        INPUT = {
          unicodemath: [["&#x2592;"], parsing_wrapper(["blockhalfshaded"], lang: :unicode)],
          asciimath: [["&#x2592;"], parsing_wrapper(["blockhalfshaded"], lang: :asciimath)],
          mathml: ["&#x2592;"],
          latex: [["blockhalfshaded", "&#x2592;"]],
          omml: ["&#x2592;"],
          html: ["&#x2592;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\blockhalfshaded"
        end

        def to_asciimath(**)
          parsing_wrapper("blockhalfshaded", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2592;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2592;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2592;"
        end

        def to_html(**)
          "&#x2592;"
        end
      end
    end
  end
end
