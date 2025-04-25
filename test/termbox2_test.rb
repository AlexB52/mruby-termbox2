require 'test_helper'

class TestTermbox2 < Minitest::Test
  def test_tb_print
    command, expectation = config_for("tb_print_hello_world")
    Shell.run(command: command) do |shell|
      assert_equal expectation, shell.screenshot
      shell.send_keys('q')
    end
  end

  def test_tb_color
    command, expectation = config_for("tb_print_color")
    Shell.run(command: command) do |shell|
      assert_equal expectation, shell.screenshot
      shell.send_keys('q')
    end
  end

  def test_tb_poll_event
    command, expectation = config_for("tb_poll_event")
    Shell.run(command: command) do |shell|
      shell.send_keys('r')
      assert_equal expectation, shell.screenshot
      shell.send_keys('q')
    end
  end

  def test_tb_height_and_width
    command, expectation = config_for("tb_height_width")
    Shell.run(command: command, height: 5, width: 50) do |shell|
      assert_equal expectation, shell.screenshot
      shell.send_keys('q')
    end
  end

  def test_tb_clear
    Shell.run(command: command("tb_clear.rb"), height: 5) do |shell|
      shell.send_keys('r')
      assert_equal "{type: 1, key: 0, ch: 114, mod: 0, x: 0, y: 0, w: 0, h: 0}\n\n\n\n\n", shell.screenshot

      shell.send_keys('c') # triggers TB2.clear

      assert_equal "\n\n\n\n\n", shell.screenshot
      shell.send_keys('q')
    end
  end

  def test_tb_set_cell
    command, expectation = config_for("tb_set_cell")
    Shell.run(command: command) do |shell|
      assert_equal expectation, shell.screenshot
      shell.send_keys('q')
    end
  end

  private

  def config_for(name)
    [
      command("#{name}.rb"),
      File.read(example("#{name}.ansi"))
    ]
  end

  def command(name)
    "bin/run #{example(name)}"
  end

  def example(name)
    File.join(Dir.pwd, "test", "examples", name)
  end
end
