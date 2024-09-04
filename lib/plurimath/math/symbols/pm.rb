module Plurimath
  module Math
    module Symbols
      class Pm < Symbol
        INPUT = {
          unicodemath: [["pm", "&#xb1;"], parsing_wrapper(["+-"], lang: :unicode)],
          asciimath: [["+-", "pm", "&#xb1;"]],
          mathml: ["&#xb1;"],
          latex: [["pm", "&#xb1;"], parsing_wrapper(["+-"], lang: :latex)],
          omml: ["&#xb1;"],
          html: ["&#xb1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\pm"
        end

        def to_asciimath(**)
          "pm"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#xb1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "&#xb1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#xb1;"
        end

        def to_html(**)
          "&#xb1;"
        end
      end
    end
  end
end
