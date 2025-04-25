TB2.init
loop do
  event = TB2.poll_event
  next unless event && event[:type] == 1

  case event[:ch].chr
  when 'q' then break
  when 'c' then TB2.clear
  else          TB2.print(0, 0, 0,0, event.inspect)
  end

  TB2.present
end
TB2.shutdown
