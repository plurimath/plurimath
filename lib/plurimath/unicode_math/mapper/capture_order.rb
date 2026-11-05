# frozen_string_literal: true

require "set"

module Plurimath
  class UnicodeMath
    class Mapper
      # The order in which the grammar captures a node's fields.
      #
      # The typed model declares a class's fields alphabetically, while the
      # grammar's sequences fold their captures in the order they match. The
      # rule table mostly does not care, but a Hash it leaves unmatched ends
      # up inside the Formula as it is, so the mapper rebuilds each Hash in
      # the grammar's order.
      #
      # The order is read from the compiled grammar that umath runs
      # (its artifact's atoms). For a node captured as +capture+ with the
      # fields +names+, every way the grammar can capture exactly those
      # names under +capture+ is listed, skipping any branch that captures
      # another name. When they all give one order, that is the order. When
      # the grammar allows more than one (x_a^b and x^b_a capture sub and sup
      # in either order and give the same model), the model does not say
      # which, so the allowed order nearest the declared one is used.
      class CaptureOrder
        NONE = Set.new.freeze
        BLANK = Set[[].freeze].freeze

        @cache = {}.compare_by_identity
        @lock = Mutex.new

        # The CaptureOrder for the grammar of the artifact entry +entry+
        # (a Hash with "atoms" and "root"), one per grammar.
        def self.for(grammar)
          @lock.synchronize { @cache[grammar] ||= new(grammar) }
        end

        attr_reader :root_capture

        def initialize(grammar)
          @atoms = grammar.fetch("atoms")
          @root_capture = @atoms.fetch(grammar.fetch("root")).fetch("Named").fetch("name").to_sym
          @named = Hash.new { |h, k| h[k] = [] }
          @atoms.each do |atom|
            named = atom["Named"] or next
            @named[named["name"]] << named["atom"]
          end
          @lists = {}
          @items = {}
          @orders = {}
          @visiting = {}
          @lock = Mutex.new
        end

        # +names+ (the node's set fields, as Symbols) in the order the
        # grammar captures them under +capture+.
        def order(capture, names)
          return names if names.size < 2

          key = [capture, names]
          @lock.synchronize { @orders[key] ||= find(capture.to_s, names) }
        end

        private

        def find(capture, names)
          wanted = names.map(&:to_s).sort.freeze
          found = Set.new
          @named.fetch(capture, []).each do |atom|
            found.merge(lists(atom, wanted))
            found.merge(items(atom, wanted))
          end
          orders = found.select { |list| list.size == wanted.size }
          return names if orders.empty?

          # Of the orders the grammar allows, the one nearest the declared
          # order: the parts the grammar fixes are kept, and only the parts
          # it leaves open follow the declaration.
          declared = names.each_with_index.to_h { |name, i| [name.to_s, i] }
          orders.min_by { |list| list.map { |name| declared[name] } }.map(&:to_sym)
        end

        # The capture orders atom +index+ can produce for one Hash, using
        # only the names in +wanted+.
        def lists(index, wanted)
          key = [index, wanted]
          return @lists[key] if @lists.key?(key)
          return BLANK if @visiting[key]

          # A rule reached again inside itself is a repetition written as
          # recursion (spaces and the like); it adds no captures there.
          @visiting[key] = true
          result = compute(@atoms[index], wanted)
          @visiting.delete(key)
          @lists[key] = result
        end

        def compute(atom, wanted)
          type, body = atom.first
          case type
          when "Named" then wanted.include?(body["name"]) ? Set[[body["name"]].freeze] : NONE
          when "Entity" then lists(body["atom"], wanted)
          when "Alternative" then body["atoms"].map { |a| lists(a, wanted) }.reduce(Set.new, :|)
          when "Sequence" then sequence(body["atoms"], wanted)
          when "Repetition"
            # A repetition of captures is a list, whose items are Hashes of
            # their own; only an optional part adds to this Hash.
            body["tag"] == "Maybe" ? BLANK | lists(body["atom"], wanted) : BLANK
          else BLANK
          end
        end

        # A sequence folds its parts' Hashes left to right; a name met again
        # keeps its first place.
        def sequence(parts, wanted)
          parts.reduce(BLANK) do |acc, part|
            later = lists(part, wanted)
            return NONE if later.empty?

            acc.flat_map { |left| later.map { |right| (left | right).freeze } }.to_set
          end
        end

        # The capture orders of the items when atom +index+ captures a list.
        def items(index, wanted, seen = Set.new)
          key = [index, wanted]
          return @items[key] if @items.key?(key)
          return NONE unless seen.add?(index)

          type, body = @atoms[index].first
          @items[key] =
            case type
            when "Entity" then items(body["atom"], wanted, seen)
            when "Alternative", "Sequence" then body["atoms"].map { |a| items(a, wanted, seen) }.reduce(Set.new, :|)
            when "Repetition"
              body["tag"] == "Maybe" ? items(body["atom"], wanted, seen) : lists(body["atom"], wanted)
            else NONE
            end
        end
      end
    end
  end
end
