WORDS = %w[apple beach chair dream earth flame grace heart image jelly knife
           light movie night ocean peace queen river stone trust unity voice
           water xenon yacht zebra bacon candy delta eagle faith ghost honey
           ivory judge karma lemon magic noble olive party quiet realm savvy
           tango urban vigor woven youth zesty]

class Game
  attr_reader :tries, :word, :attempts
  def initialize(word: nil, words: WORDS)
    @word = (word || words.sample).downcase
    @attempts = Array.new(6)
    @tries = 0
    @letters = Hash.new { |h,k| h[k] = :available }
  end

  def attempts=(value)
    @attempts = value
  end

  def guess(try)
    return if @tries > 6

    @attempts[@tries] = try.downcase
    @tries += 1
  end

  def won?
    attempts.include?(word)
  end

  def lost?
    tries >=6 && !attempts.include?(word)
  end

  def state
    { attempts: attempts, tries: tries, word: word, won: won?, loose: lost? }
  end

  def letters
    # states = [:used, :guessed, :locked, :available]
    attempts.reject(&:nil?).each do |attempt|
      attempt.chars.each.with_index do |char, i|
        if word[i] == char
          @letters[char] = :locked
        elsif word.include?(char)
          @letters[char] = :guessed unless %i[locked].include?(@letters[char])
        else
          @letters[char] = :used unless %i[guessed locked].include?(@letters[char])
        end
      end
    end
    @letters
  end
end

module View
  TEMPLATE = <<~TEMPLATE
        W O R D L E
    +-----------------+
    |                 |
    |  _  _  _  _  _  |
    |                 |
    |  _  _  _  _  _  |
    |                 |
    |  _  _  _  _  _  |
    |                 |
    |  _  _  _  _  _  |
    |                 |
    |  _  _  _  _  _  |
    |                 |
    |  _  _  _  _  _  |
    |                 |
    +-----------------+

    A B C D E F G H I J
    K L M N O P Q R S T
        U V W X Y Z
  TEMPLATE

  def self.anchor(tb: TB2)
    lines = TEMPLATE.split("\n")
    x = (tb.width - lines.map(&:length).max) / 2
    y = (tb.height - lines.length) / 2

    [x,y]
  end

  def self.template
    TEMPLATE
  end
end

def draw_loose(word:, tb: TB2)
  x, y = View.anchor

  draw_view
  tb.print(x+1,y+7,0,2,"  _  Y  O  U  _  ")
  tb.print(x+1,y+9,0,2,"  L  O  O  S  E  ")
  tb.print(x+3,y+13,0,2, word.each_char.to_a.join("  ").upcase)
  tb.hide_cursor
end

def draw_win(tb: TB2)
  x, y = View.anchor

  draw_view
  tb.print(x+1,y+7,0,3,"  _  Y  O  U  _  ")
  tb.print(x+1,y+9,0,3,"  _  W  I  N  _  ")
  tb.hide_cursor
end

def draw_view(tb: TB2)
  lines = View.template.split("\n")
  x, y = View.anchor
  lines.each.with_index do |line, i|
    tb.print(x, y+i, 0, 0, line)
  end
end

def draw_attempts(word:, attempts: [], tb: TB2)
  x, y = View.anchor

  attempts.each.with_index do |attempt, i|
    c_x = x
    c_y = y + 3 + i * 2

    attempt.each_char.with_index do |char, j|
      c_x += 3
      if char == word[j]
        tb.set_cell(c_x, c_y, 0, 3, char.upcase.ord)
      elsif word.include?(char)
        tb.set_cell(c_x, c_y, 0, 4, char.upcase.ord)
      else
        tb.set_cell(c_x, c_y, 0, 0, char.upcase.ord)
      end
    end
  end
end

def draw_current_attempt(tries: 0, letters: [], tb: TB2)
  x, y = View.anchor

  c_y = y + 3 + tries * 2

  if tries < 6
    c_x = ([letters.length, 4].min) * 3 + x + 3
    tb.set_cursor(c_x, c_y)
  end

  a_x = x
  letters.each.with_index do |char, j|
    a_x += 3
    tb.set_cell(a_x, c_y, 0, 0, char.upcase.ord)
  end
end

def draw_keyboard(game:, tb: TB2)
  game.letters.keys.each do |letter|
    x, y = View.anchor
    y += 17

    if index = "A B C D E F G H I J".index(letter.upcase)
      x += index
    elsif index = "K L M N O P Q R S T".index(letter.upcase)
      y += 1
      x += index
    elsif index = "    U V W X Y Z".index(letter.upcase)
      y += 2
      x += index
    end

    fg, bg = case game.letters[letter]
      when :locked  then [0, 3]
      when :guessed then [0, 4]
      when :used    then [1, 1]
      else               [0, 0]
      end

    tb.set_cell(x, y, fg, bg, letter.upcase.ord)
  end
end

game = Game.new(word: "world")
%w[water xenon yacht].each { |word| game.guess(word) }

game = Game.new

letters = []
TB2.init
loop do
  TB2.clear
  draw_view
  draw_attempts(word: game.word, attempts: game.attempts.reject(&:nil?))
  draw_current_attempt(tries: game.tries, letters: letters)
  draw_keyboard(game: game)
  TB2.present

  if game.won?
    TB2.clear
    draw_win
    TB2.present
    TB2.poll_event
    break
  end

  if game.lost?
    TB2.clear
    draw_loose(word: game.word)
    TB2.present
    TB2.poll_event
    break
  end

  next unless (event = TB2.poll_event) && event[:type] == 1

  if ('a'..'z').include?(event[:ch]&.chr)
    next if letters.length >= 5
    letters << event[:ch].chr

  elsif event[:key] == 127 # DELETE
    letters.pop

  elsif event[:key] == 13 # ENTER
    next unless letters.length >= 5
    game.guess(letters.join)
    letters = []
  end

  if event[:key] == 27 # ESCAPE
    break
  end
rescue => e
  TB2.shutdown
  raise e
end
TB2.shutdown