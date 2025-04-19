module Termbox2
  FLAG_MAP = {
    esc:   (ESC   = 1),
    alt:   (ALT   = 2),
    mouse: (MOUSE = 4),
  }.freeze

  # Termbox2.set_input_mode(:esc, :mouse)
  def self.set_input_mode(*args)
    mode = args.reduce(0) { |mask, argument| mask | FLAG_MAP[argument] }
    self.set_native_input_mode(mode)
  end
end
