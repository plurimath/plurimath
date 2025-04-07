require "parslet"

EMPTY_RE = Regexp.compile("")

module Parslet
  class Source
    def lookahead?(pattern)
      @str.match?(pattern)
    end
  end
end

class Parslet::Atoms::Base
  def lookahead?(source)
    # Assume lookup is successful by default
    # Override in child classes by need
    true
  end

  def first_char_re
    # Override in child classes by need
    EMPTY_RE
  end
end

class Parslet::Atoms::Alternative < Parslet::Atoms::Base
  # Lazy init
  # We can't do this in constructor because Parslet::Atoms::Alternative is built incrementally
  def apply_group_optimization()
    return @grouped_optimization unless @grouped_optimization.nil?

    alternatives = @alternatives
    @alternatives_by_char = {}
    @grouped_optimization = false

    # Try to group the alternatives by the first character
    # This way we can skip multiple alternatives in one lookahead
    # Only apply this optimization to huge alternatives (for now?)
    if alternatives.size >= 10
      non_empty = 0
      alternatives.each do | a|
        re = a.first_char_re
        @alternatives_by_char[re] ||= []
        @alternatives_by_char[re] << a
        non_empty += 1 if re != EMPTY_RE
      end
      @grouped_optimization = non_empty >= alternatives.size / 2
    end
  end

  def lookahead?(source)
    # We need to stop the recursive lookahead at some point, otherwise it might go too deep
    true
  end

  def try(source, context, consume_all)
    # TODO: this optimization should be disabled if the order of @alternatives matters
    if apply_group_optimization
      @alternatives_by_char.each_key do |ch|
        char_alternatives = @alternatives_by_char[ch]
        if source.lookahead?(ch)
          char_alternatives.each { |a|
            next unless a.lookahead?(source)

            success, _ = result = a.apply(source, context, consume_all)
            return result if success
          }
        end
      end
    else
      alternatives.each { |a|
        # Instead of entering the more expensive apply() method,
        # we attempt to look ahead and continue to the next alternative if there's no match
        # The `Constants.precompile_constants` alternative has over 3k options
        next unless a.lookahead?(source)

        success, _ = result = a.apply(source, context, consume_all)
        return result if success
      }
    end

    # If we reach this point, all alternatives have failed.
    context.err(self, source, error_msg)
  end

  precedence ALTERNATE
  def to_s_inner(prec)
    # Don't dump all the alternatives, it takes too much time
    limit = 5
    items = alternatives.first(limit)
                        .map { |a| "#{a.class}[#{a.to_s(prec).gsub("\n", " ")}]" }
                        .join(' / ')

    if alternatives.size > limit
      items += " and (#{alternatives.size - limit}) more"
    end

    items
  end
end

class Parslet::Atoms::Sequence < Parslet::Atoms::Base
  def is_combined_re
    return @is_combined unless @is_combined.nil?

    return @is_combined = false if @parslets.length < 2
    @is_combined = false

    first_are_re = @parslets[0...-1].all? { | parslet | parslet.is_a?(Parslet::Atoms::Re) }
    if first_are_re
      last_re = @parslets[-1].is_a?(Parslet::Atoms::Re)
      last_lookahead = @parslets[-1].is_a?(Parslet::Atoms::Lookahead) && @parslets[-1].bound_parslet.is_a?(Parslet::Atoms::Re)
      if last_lookahead or last_re
        combined = @parslets.map { |p| p.match}.join
        @combined_re = Regexp.compile(combined)
        @is_combined = true
      end
    end
    @is_combined
  end

  def error_msgs
    @error_msgs ||= {
      failed: "Failed to match sequence (<omited for performance reasons>)"
    }
  end

  def lookahead?(source)
    return source.lookahead?(@combined_re) if is_combined_re
    parslets[0].lookahead?(source)
  end

  def first_char_re
    parslets[0].first_char_re
  end

  def try(source, context, consume_all)
    # Lazy init array
    result = nil

    parslets.each_with_index do |p, idx|
      unless p.lookahead?(source)
        return context.err(self, source, error_msgs[:failed])
      end

      child_consume_all = consume_all && (idx == parslets.size-1)
      success, value = p.apply(source, context, child_consume_all)

      unless success
        return context.err(self, source, error_msgs[:failed])
      end

      if result.nil?
        result = Array.new(parslets.size + 1)
        result[0] = :sequence
      end
      result[idx+1] = value
    end

    succ(result)
  end
end

class Parslet::Atoms::Str < Parslet::Atoms::Base
  def lookahead?(source)
    source.lookahead?(@pat)
  end

  def compute_re
    return @re1 unless @re1.nil?
    @re1 = Regexp.compile(Regexp.escape(@str[0]))
  end

  def first_char_re
    compute_re
  end
end

class Parslet::Atoms::Named < Parslet::Atoms::Base
  def lookahead?(source)
    @parslet.lookahead?(source)
  end

  def first_char_re
    @parslet.first_char_re
  end
end

class Parslet::Atoms::Lookahead < Parslet::Atoms::Base
  def match
    next_re = @bound_parslet.match
    return next_re if @positive
    "[^" + next_re[1...]
  end

  def lookahead?(source)
    return @bound_parslet.lookahead?(source) if @positive
    # negative case covered below
    true
  end

  def first_char_re
    return @bound_parslet.first_char_re if @positive
    EMPTY_RE
  end

  def try(source, context, consume_all)
    rewind_pos  = source.bytepos
    error_pos   = source.pos

    # Exit early for non-match
    if not positive and not bound_parslet.lookahead?(source)
      return succ(nil)
    end

    success, _ = bound_parslet.apply(source, context, consume_all)

    if positive
      return succ(nil) if success
      return context.err_at(self, source, error_msgs[:positive], error_pos)
    else
      return succ(nil) unless success
      return context.err_at(self, source, error_msgs[:negative], error_pos)
    end

    # This is probably the only parslet that rewinds its input in #try.
    # Lookaheads NEVER consume their input, even on success, that's why.
  ensure
    source.bytepos = rewind_pos
  end
end

class Parslet::Atoms::Entity < Parslet::Atoms::Base
  def lookahead?(source)
    parslet.lookahead?(source)
  end

  def first_char_re
    parslet.first_char_re
  end
end

class Parslet::Atoms::Re < Parslet::Atoms::Base
  def lookahead?(source)
    source.lookahead?(@re)
  end

  def compute_re
    return @re1 unless @re1.nil?
    re = EMPTY_RE
    m = @match
    re = Regexp.compile(m[0..4]) if m[0] == '[' and m[3] == ']'
    @re1 = re
  end

  def first_char_re
    compute_re
  end
end

class Parslet::Atoms::Repetition < Parslet::Atoms::Base
  def lookahead?(source)
    return true if @min == 0
    @parslet.lookahead?(source)
  end
end
