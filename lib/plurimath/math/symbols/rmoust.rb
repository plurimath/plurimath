module Plurimath
  module Math
    module Symbols
      class Rmoust < Symbol
        INPUT = {
          unicodemath: [["rmoust", "&#x23b1;"], parsing_wrapper(["rmoustache"], lang: :unicode)],
          asciimath: [["&#x23b1;"], parsing_wrapper(["rmoust", "rmoustache"], lang: :asciimath)],
          mathml: ["&#x23b1;"],
          latex: [["rmoustache", "&#x23b1;"], parsing_wrapper(["rmoust"], lang: :latex)],
          omml: ["&#x23b1;"],
          html: ["&#x23b1;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\rmoustache"
        end

        def to_asciimath(**)
          parsing_wrapper("rmoust", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x23b1;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x23b1;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x23b1;"
        end

        def to_html(**)
          "&#x23b1;"
        end
      end
    end
  end
end
