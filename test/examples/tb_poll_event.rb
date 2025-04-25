TB2.init
TB2.print(0, 0, 0, 0, "hello from termbox")
TB2.present
event = TB2.poll_event
until event && event[:type] == 1 && event[:ch].chr == 'q'
  TB2.print(0, 1, 0,0, event.inspect)
  TB2.present
  event = TB2.poll_event
end
TB2.shutdown
