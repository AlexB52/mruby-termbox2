TB2.init
TB2.print(0, 0, 0,0, "hello from termbox")
TB2.present
while (event = TB2.poll_event)[:ch].chr != 'q'
  TB2.print(0, 1, 0,0, event.inspect)
  TB2.present
end
TB2.shutdown
