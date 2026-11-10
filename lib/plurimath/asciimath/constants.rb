# frozen_string_literal: true

module Plurimath
  class Asciimath
    class Constants
      TABLE_PARENTHESIS = {
        "ᑕ": "ᑐ",
        "ℒ": "ℛ",
        "[": "]",
        "(": ")",
      }.freeze
      SUB_SUP_CLASSES = %w[lim log].freeze
    end
  end
end
