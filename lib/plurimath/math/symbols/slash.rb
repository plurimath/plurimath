module Plurimath
  module Math
    module Symbols
      class Slash < Symbol
        INPUT = {
          unicodemath: [["&#x2215;", "\/"], parsing_wrapper(["divslash", "slash"], lang: :unicode)],
          asciimath: [["//", "&#x2215;"], parsing_wrapper(["divslash", "slash"], lang: :asciimath)],
          mathml: ["&#x2215;"],
          latex: [["divslash", "slash", "/", "&#x2215;"]],
          omml: ["&#x2215;"],
          html: ["&#x2215;"],
        }.freeze

        # output methods
        def to_latex(**)
          "/"
        end

        def to_asciimath(**)
          "//"
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode("\/")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << "/"
        end

        def to_omml_without_math_tag(_, **)
          "/"
        end

        def to_html(**)
          "/"
        end
      end
    end
  end
end
