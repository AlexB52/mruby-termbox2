WORDS = %w[Abundance Adventure Beautiful Butterfly Centennial Celebration Compassion Confidence
           Connection Creativity Deliciously Determination Development Enthusiasm Extraordinary
           Fascinating Friendliness Generosity Imagination Inspiration Intelligence Introduction
           Justifiable Knowledgeable Leadership Magnificent Motivation Opportunity Perception
           Perseverance Phenomenon Photography Presentation Productivity Relationship Resilience
           Responsibility Satisfaction Simplicity Spectacular Telecommunications Understanding
           Unforgettable Vulnerability Whimsicality Transcendence Collaboration Electrification
           Immaculate Juxtaposition]

HANGMAN_TEMPLATE = <<~TEMPLATE
  +---+
  |   |
  O   |
 /|\\  |
 / \\  |
      |
=========
TEMPLATE

class Game
  attr_reader :letters, :stage, :word
  def initialize(word: nil, words: %w[hello world])
    @word = (word || words.sample).downcase
    @stage = 0
    @letters = Set.new
  end

  def guess(letter)
    letter.downcase!
    @letters << letter
    @stage += 1 unless word.include?(letter)
  end

  def won?
    Set.new(word.chars).subset?(letters)
  end

  def lost?
    stage >= 6
  end
end

def erase(x, y, tb: TB2)
  tb.set_cell(x, y, 0, 0, ' '.ord)
end

def draw_hangman(stage:, tb: TB2)
  HANGMAN_TEMPLATE.split("\n").each.with_index(0) { |line, y| tb.print(0, y, 0, 0, line) }
  hangman = [[1, 4], [3, 4], [1, 3], [2, 3], [3, 3], [2, 2]]
  stage.times { hangman.pop }
  hangman.each { |x,y| erase(x, y) }
end

def draw_word(word:, letters:)
  result = '_' * word.length
  word.each_char.with_index do |char, index|
    next unless letters.include?(word[index])
    result[index] = char
  end

  TB2.print(0, 8, 0, 0, "Word to find: #{result}")
end

game = Game.new(words: WORDS)

TB2.init
loop do
  draw_hangman(stage: game.stage)
  draw_word(word: game.word, letters: game.letters)
  TB2.present

  if game.won?
    TB2.print(0, 10, 2, 3, "YOU WIN!")
    TB2.print(0, 11, 0, 0, "Press [SPACE] to replay or another key to exit...")
    TB2.present
    event = TB2.poll_event
    if event && event[:type] == 1 && event[:ch].chr == ' '
      game = Game.new(words: WORDS)
      TB2.clear
      next
    end
    break

  elsif game.lost?
    TB2.print(0, 10, 2, 3, "YOU LOST! The word was '#{game.word}'")
    TB2.print(0, 11, 0, 0, "Press [SPACE] to replay or another key to exit...")
    TB2.present
    event = TB2.poll_event
    if event && event[:type] == 1 && event[:ch].chr == ' '
      game = Game.new(words: WORDS)
      TB2.clear
      next
    end
    break

  else
    event = TB2.poll_event
    next unless event && event[:type] == 1
    game.guess(event[:ch].chr)
  end
rescue => e
  TB2.shutdown
  raise e
  break
end
TB2.shutdown