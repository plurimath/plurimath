require_relative "../render.so"

class Render
  attr_reader :input, :maxsize, :max_time, :max_memory, :file_format
  
  DEFAULT_OPTS = {
    ppi: 72.0,
    zoom: 1.0,
    base64: false,
    maxsize: 0,
    format: :svg,
    delimiter: [:DOLLAR, :DOUBLE],
  }

  def initialize(
      input:,
      maxsize: DEFAULT_OPTS[:maxsize],
      file_format: DEFAULT_OPTS[:format]
    )
    @input = input
    @maxsize = maxsize
    @max_time = max_time
    @max_memory = max_memory
    @format = file_format
  end

  def process
    process()
  end

  def process_helper(input)
    process_helper(input)
  end

  def render(input)
    render(input)
  end
end