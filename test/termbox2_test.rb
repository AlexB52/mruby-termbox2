require 'test_helper'

class TestTermbox2 < Minitest::Test
  def test_tb_print
    command, expectation = config_for("tb_print_hello_world")
    Shell.run(command: command) do |shell|
      assert_equal expectation, shell.screenshot
      shell.send_key('q')
    end
  end

  def test_tb_color
    command, expectation = config_for("tb_print_color")
    Shell.run(command: command) do |shell|
      assert_equal expectation, shell.screenshot
      shell.send_key('q')
    end
  end

  def test_tb_poll_event
    command, expectation = config_for("tb_poll_event")
    Shell.run(command: command) do |shell|
      shell.send_key('r')
      assert_equal expectation, shell.screenshot
      shell.send_key('q')
    end
  end

  def config_for(name)
    [
      "bin/run ./test/examples/#{name}.rb",
      File.read("test/examples/#{name}.ansi")
    ]
  end
end
