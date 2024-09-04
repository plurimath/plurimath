module Plurimath
  module Math
    module Symbols
      class Bigblacktriangledown < Symbol
        INPUT = {
          unicodemath: [["&#x25bc;"], parsing_wrapper(["bigblacktriangledown"], lang: :unicode)],
          asciimath: [["&#x25bc;"], parsing_wrapper(["bigblacktriangledown"], lang: :asciimath)],
          mathml: ["&#x25bc;"],
          latex: [["bigblacktriangledown", "&#x25bc;"]],
          omml: ["&#x25bc;"],
          html: ["&#x25bc;"],
        }.freeze

        # output methods
        def to_latex(**)
          "\\bigblacktriangledown"
        end

        def to_asciimath(**)
          parsing_wrapper("bigblacktriangledown", lang: :asciimath)
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("&#x25bc;")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mi") << "&#x25bc;"
        end

        def to_omml_without_math_tag(_, **)
          "&#x25bc;"
        end

        def to_html(**)
          "&#x25bc;"
        end
      end
    end
  end
end
