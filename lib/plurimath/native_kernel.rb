# frozen_string_literal: true

require "digest"
require "digest/sha2"
require "fiddle"

module Plurimath
  # Explicitly opt in to the canonical ABI. Native code owns all result
  # semantics, including provenance stamps and typed evaluation refusals.
  class NativeKernel
    class LoadError < StandardError; end
    class UnsupportedABI < LoadError; end
    class NativeRuntimeError < StandardError; end
    class ResultUnavailable < NativeRuntimeError; end
    class AllocationError < NativeRuntimeError; end

    def initialize(library_path, sha256:)
      path = File.expand_path(library_path)
      unless Digest::SHA256.file(path).hexdigest == sha256
        raise LoadError, "Plurimath native library digest mismatch"
      end

      @handle = Fiddle.dlopen(path)
      version = function("plurimath_numeric_abi_version", [], Fiddle::TYPE_INT32_T)
      raise UnsupportedABI, "unsupported Plurimath ABI" unless version.call == 1

      @evaluate = function("plurimath_numeric_evaluate",
                           [Fiddle::TYPE_VOIDP, Fiddle::TYPE_SIZE_T], Fiddle::TYPE_VOIDP)
      @free = function("plurimath_numeric_result_free",
                       [Fiddle::TYPE_VOIDP], Fiddle::TYPE_VOID)
    rescue Fiddle::DLError, SystemCallError => e
      raise LoadError, e.message
    end

    def evaluate_json(request)
      raise TypeError, "evaluation request must be a String" unless request.is_a?(String)

      # The ABI borrows the Ruby string bytes for this one synchronous call.
      result = @evaluate.call(Fiddle::Pointer[request], request.bytesize)
      raise ResultUnavailable, "Plurimath native ABI returned NULL" if result.null?

      begin
        copy_response(result)
      ensure
        @free.call(result)
      end
    rescue NoMemoryError => e
      raise AllocationError, e.message
    end

    alias call evaluate_json

    private

    def function(symbol, parameters, result)
      # Keep the Ruby input buffer stable while native code borrows it.
      Fiddle::Function.new(@handle[symbol], parameters, result, need_gvl: true)
    end

    def copy_response(pointer)
      pointer.to_s.force_encoding(Encoding::UTF_8)
    end
  end
end
