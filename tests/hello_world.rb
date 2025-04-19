y = 0
TB2.init
TB2.print(0, y, 0,0, "hello from termbox")
TB2.print(0, y+=1, 0,0, "width=#{TB2.width} height=#{TB2.height}")
TB2.print(0, y+=1, 0,0, "press any key...")
TB2.set_cursor(10, 10)
TB2.set_cell(12, 12, 0, 0, 'A'.ord)
TB2.present

event = TB2.poll_event

TB2.print(0, y+=1, 0,0, event.inspect)
TB2.print(0, y+=1, 0,0, event[:ch].chr)
TB2.print(0, y+=1, 0,0, "press any key to quit...")
TB2.present

event = TB2.poll_event
TB2.tb_shutdown
