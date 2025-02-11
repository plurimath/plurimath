# frozen_string_literal: true

require_relative "constants"
require "mml"

module Plurimath
  class Mathml
    class Parser
      CONFIGURATION = {
        Mml::MathWithNilNamespace => Plurimath::Math::Formula,
        Mml::MathWithNamespace => Plurimath::Math::Formula,
        Mml::Mmultiscripts => Plurimath::Math::Function::Multiscript,
        Mml::Mlabeledtr => Plurimath::Math::Function::Mlabeledtr,
        Mml::Munderover => Plurimath::Math::Function::Underover,
        Mml::Semantics => Plurimath::Math::Function::Semantics,
        Mml::Mscarries => Plurimath::Math::Function::Scarries,
        Mml::Mfraction => Plurimath::Math::Function::Frac,
        Mml::Menclose => Plurimath::Math::Function::Menclose,
        Mml::Mlongdiv => Plurimath::Math::Function::Longdiv,
        Mml::Mphantom => Plurimath::Math::Function::Phantom,
        Mml::Msubsup => Plurimath::Math::Function::PowerBase,
        Mml::Msgroup => Plurimath::Math::Function::Msgroup,
        Mml::Mpadded => Plurimath::Math::Function::Mpadded,
        Mml::Mfenced => Plurimath::Math::Function::Fenced,
        Mml::Mstack => Plurimath::Math::Function::Stackrel,
        Mml::Munder => Plurimath::Math::Function::Underset,
        Mml::Msline => Plurimath::Math::Function::Msline,
        Mml::Merror => Plurimath::Math::Function::Merror,
        Mml::Mtable => Plurimath::Math::Function::Table,
        Mml::Mstyle => Plurimath::Math::Formula::Mstyle,
        Mml::Mglyph => Plurimath::Math::Function::Mglyph,
        Mml::Mover => Plurimath::Math::Function::Overset,
        Mml::Msqrt => Plurimath::Math::Function::Sqrt,
        Mml::Mroot => Plurimath::Math::Function::Root,
        Mml::Mtext => Plurimath::Math::Function::Text,
        Mml::Mfrac => Plurimath::Math::Function::Frac,
        Mml::Msrow => Plurimath::Math::Formula,
        Mml::Msup => Plurimath::Math::Function::Power,
        Mml::Msub => Plurimath::Math::Function::Base,
        Mml::None => Plurimath::Math::Function::None,
        Mml::Mrow => Plurimath::Math::Formula::Mrow,
        Mml::Mtd => Plurimath::Math::Function::Td,
        Mml::Mtr => Plurimath::Math::Function::Tr,
        Mml::Mi => Plurimath::Math::Symbols::Symbol,
        Mml::Mo => Plurimath::Math::Symbols::Symbol,
        Mml::Ms => Plurimath::Math::Function::Ms,
        Mml::Mn => Plurimath::Math::Number,
      }
      attr_accessor :text
      @@models_set = false

      def initialize(text)
        mml_config unless @@models_set
        @text = text
      end

      def parse
        namespace_exist = text.split(">").first.include?(" xmlns=")
        Mml.parse(text, namespace_exist: namespace_exist)
      end

      def mml_config
        Mml::Configuration.custom_models = CONFIGURATION
        @@models_set = true
      end
    end
  end
end
