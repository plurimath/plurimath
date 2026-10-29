# frozen_string_literal: true

module Plurimath
  module Math
    # Raised when a format's parser needs a gem that cannot be loaded. It is
    # a ParseError, so Math.parse passes it through with this message instead
    # of the generic one, and callers rescuing ParseError still catch it.
    class MissingDependencyError < ParseError
      def initialize(type, format_name:, gem_name:, gemfile_line:)
        @format_name = format_name
        @gem_name = gem_name
        @gemfile_line = gemfile_line
        super(nil, type)
      end

      def parsing_message
        "[plurimath] #{@format_name} parsing needs the #{@gem_name} gem, " \
          "which could not be loaded; add #{@gemfile_line} to your Gemfile " \
          "and run `bundle install`."
      end
    end
  end
end
