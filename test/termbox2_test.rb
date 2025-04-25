require 'test_helper'

class TestTermbox2 < Minitest::Test
  def test_tb_print
    command = "bin/run ./test/examples/tb_print_hello_world.rb"
    Shell.run(command: command) do |shell|
      assert_equal File.read("test/examples/tb_print_hello_world.ansi"), shell.screenshot
      shell.send_key('q')
    end
  end

  def test_tb_color
    command = "bin/run ./test/examples/tb_print_color.rb"
    Shell.run(command: command) do |shell|
      assert_equal File.read("test/examples/tb_print_color.ansi"), shell.screenshot
      shell.send_key('q')
    end
  end

  def test_tb_poll_event
    command = "bin/run ./test/examples/tb_poll_event.rb"
    Shell.run(command: command) do |shell|
      shell.send_key('r')
      assert_equal File.read("test/examples/tb_poll_event.ansi"), shell.screenshot
      shell.send_key('q')
    end
  end
end
