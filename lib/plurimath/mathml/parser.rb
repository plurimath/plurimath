# frozen_string_literal: true

require_relative "constants"

module Plurimath
  class Mathml
    class Parser
      attr_accessor :text

      def initialize(text)
        mml_config
        @text = text
      end

      def parse
        namespace_exist = text.split(">").first.include?(" xmlns=")
        ::Mml.parse(text, namespace_exist: namespace_exist)
      end

      private

      def mml_config
        return if ::Mml.respond_to?(:config)

        ::Mml::Configuration.config = {
          mmultiscripts: Plurimath::Math::Function::Multiscript,
          mlabeledtr: Plurimath::Math::Function::Mlabeledtr,
          munderover: Plurimath::Math::Function::Underover,
          semantics: Plurimath::Math::Function::Semantics,
          mscarries: Plurimath::Math::Function::Scarries,
          mfraction: Plurimath::Math::Function::Frac,
          menclose: Plurimath::Math::Function::Menclose,
          mlongdiv: Plurimath::Math::Function::Longdiv,
          mphantom: Plurimath::Math::Function::Phantom,
          msubsup: Plurimath::Math::Function::PowerBase,
          msgroup: Plurimath::Math::Function::Msgroup,
          mpadded: Plurimath::Math::Function::Mpadded,
          mfenced: Plurimath::Math::Function::Fenced,
          mstack: Plurimath::Math::Function::Stackrel,
          munder: Plurimath::Math::Function::Underset,
          msline: Plurimath::Math::Function::Msline,
          merror: Plurimath::Math::Function::Merror,
          mtable: Plurimath::Math::Function::Table,
          mstyle: Plurimath::Math::Formula::Mstyle,
          mglyph: Plurimath::Math::Function::Mglyph,
          mover: Plurimath::Math::Function::Overset,
          msqrt: Plurimath::Math::Function::Sqrt,
          mroot: Plurimath::Math::Function::Root,
          mtext: Plurimath::Math::Function::Text,
          mfrac: Plurimath::Math::Function::Frac,
          msrow: Plurimath::Math::Formula,
          msup: Plurimath::Math::Function::Power,
          msub: Plurimath::Math::Function::Base,
          none: Plurimath::Math::Function::None,
          mrow: Plurimath::Math::Formula::Mrow,
          math: Plurimath::Math::Formula,
          mtd: Plurimath::Math::Function::Td,
          mtr: Plurimath::Math::Function::Tr,
          mi: Plurimath::Math::Symbols::Symbol,
          mo: Plurimath::Math::Symbols::Symbol,
          ms: Plurimath::Math::Function::Ms,
          mn: Plurimath::Math::Number,
        }
        require "mml"
      end
    end
  end
end
