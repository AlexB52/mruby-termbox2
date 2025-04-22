TB2.init
TB2.set_input_mode(:esc, :mouse)
TB2.print(0, 0, 0,0, "hello from termbox")
TB2.print(0, 1, 0,0, "press any key to quit...")
TB2.present
y = 2
while true
  event = TB2.peek_event(1000)
  if event
    break if event[:ch].chr == 'q'
    TB2.print(0, y, 0,0, event.inspect)
  else
    TB2.print(0, y, 0,0, "Too late")
  end
  TB2.present
  y+=1
end
TB2.tb_shutdown
