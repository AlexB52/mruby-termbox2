TB2.init
TB2.set_cell(4,3,0,0,'A'.ord)
TB2.set_cell(0,8,2,3,'T'.ord)
TB2.present
event = TB2.poll_event
TB2.shutdown
