class Line
  include Enumerable

  CHARS = (
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ" +
    "abcdefghijklmnopqrstuvwxyz" +
    "0123456789" +
    "アイウエオカキクケコサシスセソタチツテトナニヌネノハヒフヘホ"
  ).chars

  attr_reader :height, :width, :length

  def initialize(width:)
    @count = Random.rand(30) + 5
    @string = CHARS.sample(@count).join
    @height = -(@count + Random.rand(20))
    @width = width
    @length = @string.length
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
      color = j == length ? 9 : 3
      tb.set_cell(@width, @height+j, color, 0, ch.ord)
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
      i += 2
    end
    result
  end
end

begin

  Tb.init

  matrix = Matrix.new(width: Tb.width, height: Tb.height)

  i = 0
  loop do
    Tb.clear

    matrix.print
    Tb.print(0,0,0,0,"#{Tb.width} x #{Tb.height} - #{i} - number of lines: #{matrix.count}")

    Tb.present

    event = Tb.peek_event(75)
    if event && event[:type] == 1
      break
    end
    i += 1
  end

rescue => e
  Tb.shutdown
  raise e
end

Tb.shutdown