class Line
  include Enumerable

  CHARS = (
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  ).chars

  attr_reader :height, :width, :length

  COLOR_DEFAULT = 0x0000
  COLOR_BLACK   = 0x0001
  COLOR_RED     = 0x0002
  COLOR_GREEN   = 0x0003
  COLOR_YELLOW  = 0x0004
  COLOR_BLUE    = 0x0005
  COLOR_MAGENTA = 0x0006
  COLOR_CYAN    = 0x0007
  COLOR_WHITE   = 0x0008

  def initialize(width:)
    @count = Random.rand(30) + 5
    @string = CHARS.sample(@count).join
    @height = -(@count + Random.rand(20))
    @width = width
    @length = @string.length
    @last_color = color(:green)
    @current_color = color(:black)
  end

  def increment
    @string += CHARS.shuffle.first
    @string = @string[1..]
    @height += 1
  end

  def position
    height - length
  end

  def each
    unless block_given?
      return @string.chars.to_enum
    end

    @string.chars.each { |char| yield char }
  end

  def to_s
    @string
  end

  def print(tb = Tb)
    each.with_index(1) do |ch, j|
      color = j == length ? @last_color : @current_color
      tb.set_cell(@width, @height+j, color, 0, ch.ord)
    end
  end

  private

  def color(value)
    case value
    when :black   then COLOR_BLACK
    when :red     then COLOR_RED
    when :green   then COLOR_GREEN
    when :yellow  then COLOR_YELLOW
    when :blue    then COLOR_BLUE
    when :magenta then COLOR_MAGENTA
    when :cyan    then COLOR_CYAN
    when :white   then COLOR_WHITE
    else
      COLOR_DEFAULT
    end
  end
end

class Matrix
  attr_reader :width, :height, :lines

  def initialize(width:, height:)
    @width = width
    @height = height
    @lines = set_lines
  end

  def print(tb = Tb)
    lines.each do |line|
      line.print(tb)
      line.increment
      if line.position == 0
        lines << Line.new(width: line.width)
      elsif line.position >= height
        lines.delete(line)
      end
    end
  end

  def count
    lines.count
  end

  def set_lines
    result = []
    i = 0
    until i > width
      result << Line.new(width: i)
      i += 3
    end
    result
  end
end

def setup
 Tb.init
 $matrix = Matrix.new(width: Tb.width, height: Tb.height)
end

def tick
  Tb.clear
  $matrix.print
  Tb.print(0,0,0,0,"#{Tb.width} x #{Tb.height} - number of lines: #{$matrix.count}")
  Tb.present

  event = Tb.peek_event(75)
  if event && event[:type] == 1
    raise 'Done'
  end
end

# begin
#   setup
#   loop do
#     tick
#   end
# rescue => e
#   Tb.shutdown
#   raise e
# end