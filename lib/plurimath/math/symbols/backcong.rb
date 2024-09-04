module Plurimath
  module Math
    module Symbols
      class Backcong < Symbol
        INPUT = {
          unicodemath: [["&#x224c;"], parsing_wrapper(["backcong"], lang: :unicode)],
          asciimath: [["&#x224c;"], parsing_wrapper(["backcong"], lang: :asciimath)],
          mathml: ["&#x224c;"],
          latex: [["backcong", "&#x224c;"]],
          omml: ["&#x224c;"],
          html: ["&#x224c;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\backcong"
        end

        def to_asciimath(**)
          parsing_wrapper("backcong", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x224c;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x224c;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x224c;"
        end

        def to_html(**)
          "&#x224c;"
        end
      end
    end
  end
end
