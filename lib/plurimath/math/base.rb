# frozen_string_literal: true

module Plurimath
  module Math
    class Base
      def initialize(field)
        field.is_a?(Parslet::Slice) ? field.to_s : field
      end

      def class_name
        self.class.name.split("::").last.downcase
      end
    end
  end
end
