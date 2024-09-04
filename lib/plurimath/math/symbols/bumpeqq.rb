module Plurimath
  module Math
    module Symbols
      class Bumpeqq < Symbol
        INPUT = {
          unicodemath: [["&#x2aae;"], parsing_wrapper(["bumpeqq"], lang: :unicode)],
          asciimath: [["&#x2aae;"], parsing_wrapper(["bumpeqq"], lang: :asciimath)],
          mathml: ["&#x2aae;"],
          latex: [["bumpeqq", "&#x2aae;"]],
          omml: ["&#x2aae;"],
          html: ["&#x2aae;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bumpeqq"
        end

        def to_asciimath(**)
          parsing_wrapper("bumpeqq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x2aae;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x2aae;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x2aae;"
        end

        def to_html(**)
          "&#x2aae;"
        end
      end
    end
  end
end
