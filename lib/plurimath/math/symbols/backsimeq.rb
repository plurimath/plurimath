module Plurimath
  module Math
    module Symbols
      class Backsimeq < Symbol
        INPUT = {
          unicodemath: [["backsimeq", "&#x22cd;"]],
          asciimath: [["&#x22cd;"], parsing_wrapper(["backsimeq"], lang: :asciimath)],
          mathml: ["&#x22cd;"],
          latex: [["backsimeq", "&#x22cd;"]],
          omml: ["&#x22cd;"],
          html: ["&#x22cd;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\backsimeq"
        end

        def to_asciimath(**)
          parsing_wrapper("backsimeq", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x22cd;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x22cd;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x22cd;"
        end

        def to_html(**)
          "&#x22cd;"
        end
      end
    end
  end
end
