# frozen_string_literal: true

module Plurimath
  module Math
    module Evaluation
      # Independent scalar PDFs. Gaussian and Student-t procedures follow
      # JCGM101 C.4/C.6; the other transforms follow 6.4 and elementary sums.
      class DistributionSampler
        def self.centers(definitions)
          definitions.map do |definition|
            unless definition.is_a?(Hash)
              raise Gum::InvalidInput, "each input needs an explicit PDF declaration"
            end
            case definition.fetch(:distribution)
            when :normal, :student_t then Gum.exact(definition.fetch(:location))
            when :rectangular, :triangular, :arcsine, :curvilinear_trapezoid
              (Gum.exact(definition.fetch(:lower)) + Gum.exact(definition.fetch(:upper))) / 2
            else raise Gum::UnsupportedModel, "unsupported sampling PDF"
            end
          end
        rescue KeyError => e
          raise Gum::InvalidInput, "missing PDF parameter: #{e.key}"
        end

        def initialize(definitions, generator, degrees:, centered: false)
          @centered = centered
          @generator = generator
          @normal_spare = nil
          @samplers = definitions.zip(degrees).map { |definition, degree| build(definition, degree) }
        end

        def draw
          values = @samplers.map(&:call)
          raise Gum::NumericalFailure, "non-finite PDF draw" unless values.all?(&:finite?)
          values
        end

        private

        def number(value)
          result = Gum.exact(value).to_f
          raise Gum::InvalidInput, "PDF parameter exceeds binary64 range" unless result.finite?
          result
        end

        def normal
          unless @normal_spare.nil?
            value = @normal_spare
            @normal_spare = nil
            return value
          end
          radius = ::Math.sqrt(-2 * ::Math.log(@generator.uniform))
          angle = 2 * ::Math::PI * @generator.uniform
          @normal_spare = radius * ::Math.sin(angle)
          radius * ::Math.cos(angle)
        end

        def student(nu)
          10_000.times do
            r1 = @generator.uniform
            r2 = @generator.uniform
            if r1 < 0.5
              denominator = 4 * r1 - 1
              next if denominator.zero?
              t = 1.0 / denominator
              v = r2 / t**2
            else
              t = 4 * r1 - 3
              v = r2
            end
            return t if v < 1 - t.abs / 2 || v < (1 + t**2 / nu)**(-(nu + 1) / 2)
          end
          raise Gum::NumericalFailure, "Student-t rejection limit exceeded"
        end

        def build(definition, degree)
          unless definition.is_a?(Hash) && definition.key?(:distribution)
            raise Gum::InvalidInput, "each input needs an explicit PDF declaration"
          end
          case definition.fetch(:distribution)
          when :normal
            mean = @centered ? 0.0 : number(definition.fetch(:location))
            sd = number(definition.fetch(:sd))
            raise Gum::InvalidInput, "normal sd must be positive" unless sd.positive?
            -> { mean + sd * normal }
          when :student_t
            mean = @centered ? 0.0 : number(definition.fetch(:location))
            scale = number(definition.fetch(:scale))
            nu = number(definition.fetch(:degrees_of_freedom))
            raise Gum::InvalidInput, "Student-t needs positive scale and nu > 2" unless scale.positive? && nu > 2
            if nu <= 2 * degree
              raise Gum::UnsupportedModel, "finite polynomial output variance requires Student-t nu greater than twice its variable degree"
            end
            -> { mean + scale * student(nu) }
          when :rectangular, :triangular, :arcsine, :curvilinear_trapezoid
            raw_lower = Gum.exact(definition.fetch(:lower))
            raw_upper = Gum.exact(definition.fetch(:upper))
            raise Gum::InvalidInput, "PDF bounds must increase" unless raw_lower < raw_upper
            width = number(raw_upper - raw_lower)
            center = @centered ? 0.0 : number((raw_lower + raw_upper) / 2)
            lower = center - width / 2
            upper = center + width / 2
            raise Gum::InvalidInput, "PDF bounds collapse in binary64" unless lower < upper
            case definition.fetch(:distribution)
            when :rectangular then -> { lower + width * @generator.uniform }
            when :triangular then -> { lower + width * (@generator.uniform + @generator.uniform) / 2 }
            when :arcsine then -> { (lower + upper) / 2 + width / 2 * ::Math.sin(2 * ::Math::PI * @generator.uniform) }
            when :curvilinear_trapezoid
              d = number(definition.fetch(:boundary_half_width))
              raise Gum::InvalidInput, "curvilinear bounds need 0 < d < half-width" unless d.positive? && 2 * d < width
              lambda do
                a = lower - d + 2 * d * @generator.uniform
                b = lower + upper - a
                a + (b - a) * @generator.uniform
              end
            end
          else
            raise Gum::UnsupportedModel, "unsupported sampling PDF"
          end
        rescue KeyError => e
          raise Gum::InvalidInput, "missing PDF parameter: #{e.key}"
        end
      end
    end
  end
end
