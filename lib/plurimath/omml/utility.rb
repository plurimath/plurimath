# frozen_string_literal: true

module Plurimath
  class Omml
    # Omml-specific helper extracted from Plurimath::Utility (code-quality
    # refactor). Subclasses Utility so bareword `Utility.<generic>` calls inside
    # Omml files keep resolving here and inherit the generic helpers.
    class Utility < Plurimath::Utility
      class << self
        def valid_class(object)
          text = object.extract_class_name_from_text
          (object.extractable? && Asciimath::Constants::SUB_SUP_CLASSES.include?(text)) ||
            Latex::Constants::SYMBOLS[text.to_sym] == :power_base
        end
      end
    end
  end
end
