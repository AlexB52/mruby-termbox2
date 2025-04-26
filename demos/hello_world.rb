TB2.init

message = "Hello, World!"
x = (TB2.width - message.length) / 2
y = TB2.height / 2

TB2.print(0, 0, 0, 0, "press any key to quit...")
TB2.print(x, y, 2, 3, message)
TB2.present
TB2.poll_event
TB2.shutdown
