module Plurimath
  module Math
    module Symbols
      class Invdiameter < Symbol
        INPUT = {
          unicodemath: [["&#x2349;"], parsing_wrapper(["invdiameter"], lang: :unicode)],
          asciimath: [["&#x2349;"], parsing_wrapper(["invdiameter"], lang: :asciimath)],
          mathml: ["&#x2349;"],
          latex: [["invdiameter", "&#x2349;"]],
          omml: ["&#x2349;"],
          html: ["&#x2349;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\invdiameter"
        end

        def to_asciimath(**)
          parsing_wrapper("invdiameter", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2349;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2349;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2349;"
        end

        def to_html(**)
          "&#x2349;"
        end
      end
    end
  end
end
