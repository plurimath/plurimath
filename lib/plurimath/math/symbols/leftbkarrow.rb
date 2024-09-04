module Plurimath
  module Math
    module Symbols
      class Leftbkarrow < Symbol
        INPUT = {
          unicodemath: [["&#x290c;"], parsing_wrapper(["leftbkarrow"], lang: :unicode)],
          asciimath: [["&#x290c;"], parsing_wrapper(["leftbkarrow"], lang: :asciimath)],
          mathml: ["&#x290c;"],
          latex: [["leftbkarrow", "&#x290c;"]],
          omml: ["&#x290c;"],
          html: ["&#x290c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\leftbkarrow"
        end

        def to_asciimath(**)
          parsing_wrapper("leftbkarrow", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x290c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x290c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x290c;"
        end

        def to_html(**)
          "&#x290c;"
        end
      end
    end
  end
end
