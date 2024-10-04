require "lutaml/model"
require_relative "mstyle"
# require_relative "mtable"
require_relative "text"
require_relative "mrow"
require_relative "mi"
require_relative "mo"

module Plurimath
  class Mathml
    module Parse
      class CommonMapping < Lutaml::Model::Serializable
        attribute :mi, Mi
        attribute :mo, Mo
        attribute :mn, Mn
        attribute :mtext, Mtext

        # attribute :mtable, Mtable
        attribute :mrow, Mrow, collection: true, default: -> { [] }
        attribute :style, Mstyle, collection: true, default: -> { [] }
        # attribute :ms, Ms, collection: true, default: -> { [] }
        # attribute :msup, Msup, collection: true, default: -> { [] }
        # attribute :msub, Msub, collection: true, default: -> { [] }
        # attribute :msubsup, Msubsup, collection: true, default: -> { [] }
        # attribute :mfrac, Mfrac, collection: true, default: -> { [] }
        # attribute :msqrt, Msqrt, collection: true, default: -> { [] }
        # attribute :mroot, Mroot, collection: true, default: -> { [] }
        # attribute :munder, Munder, collection: true, default: -> { [] }
        # attribute :mover, Mover, collection: true, default: -> { [] }
        # attribute :munderover, Munderover, collection: true, default: -> { [] }
        # attribute :mphantom, Mphantom, collection: true, default: -> { [] }
        # attribute :merror, Merror, collection: true, default: -> { [] }
        # attribute :mpadded, Mpadded, collection: true, default: -> { [] }
        # attribute :mspace, Mspace, collection: true, default: -> { [] }
        # attribute :mstyle, Mstyle, collection: true, default: -> { [] }
        # attribute :mprescripts, Mprescripts, collection: true, default: -> { [] }


        xml do
          root self.root, mixed: self&.mixed

          map_element :mstyle, to: :style
          map_element :mrow, to: :mrow
          map_element :mi, to: :mi
          map_element :mo, to: :mo
          map_element :mtable, to: :mtable
          map_element :mtext, to: :mtext
          map_element :mn, to: :mn
          # map_element :ms, to: :ms
          # map_element :msup, to: :msup
          # map_element :msub, to: :msub
          # map_element :msubsup, to: :msubsup
          # map_element :mfrac, to: :mfrac
          # map_element :msqrt, to: :msqrt
          # map_element :mroot, to: :mroot
          # map_element :munder, to: :munder
          # map_element :mover, to: :mover
          # map_element :munderover, to: :munderover
          # map_element :mphantom, to: :mphantom
          # map_element :merror, to: :merror
          # map_element :mpadded, to: :mpadded
          # map_element :mspace, to: :mspace
          # map_element :mprescripts, to: :mprescripts
        end
      end
    end
  end
end
