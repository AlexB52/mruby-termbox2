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

  class Event
    TYPE_KEY = 1
    TYPE_RESIZE = 2
    TYPE_MOUSE = 3

    KEYS = {
      CHAR: 0,
      ESCAPE: 27,
      DELETE: 127,
      ENTER: 13
    }

    attr_reader :event

    def initialize(event)
      @event = event
    end

    def [](value)
      event[value]
    end

    def inspect
      event.inspect
    end

    def present?
      !empty?
    end

    def empty?
      event.nil? || event.empty?
    end

    def type
      case event[:type]
      when TYPE_KEY    then :key
      when TYPE_RESIZE then :resize
      when TYPE_MOUSE  then :mouse
      end
    end

    def key
      KEYS.invert[event[:key]]
    end

    def char
      return unless key?
      event[:ch].chr
    end

    def key?(value = nil)
      return false unless event && event[:type] == TYPE_KEY

      if value.nil?
        return true
      end

      case value
      when :ESCAPE
        event[:key] == KEYS[:ESCAPE]
      else
        char == value
      end
    end

    def resize?
      event && event[:type] == TYPE_RESIZE
    end

    def mouse?
      event && event[:type] == TYPE_MOUSE
    end
  end
end
