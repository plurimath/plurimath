module Plurimath
  module Math
    module Symbols
      class Comma < Symbol
        INPUT = {
          unicodemath: [["&#x2c;", ","], parsing_wrapper(["comma"], lang: :unicode)],
          asciimath: [[",", "&#x2c;"], parsing_wrapper(["comma"], lang: :asciimath)],
          mathml: ["&#x2c;", ","],
          latex: [["comma", ",", "&#x2c;"]],
          omml: ["&#x2c;", ","],
          html: ["&#x2c;", ","],
        }.freeze

        # output methods
        def to_latex(**)
          ","
        end

        def to_asciimath(options:)
          options[:table] ? "\",\"" : ","
        end

        def to_unicodemath(**)
          Utility.html_entity_to_unicode(",")
        end

        def to_mathml_without_math_tag(_, **)
          ox_element("mo") << ","
        end

        def to_omml_without_math_tag(_, **)
          ","
        end

        def to_html(**)
          "&#x2c;"
        end
      end
    end
  end
end
