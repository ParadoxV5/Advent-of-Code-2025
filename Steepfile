target '00' do
  check '*.rb'
  signature '*.rbs'
end

(1..0).each do|day|
  id = day.to_s.rjust 2, '0'
  target id do
    glob = File.join "#{id}*", '**', ''
    check     "#{glob}*.rb"
    ignore    "#{glob}golf*.rb"
    signature '*.rbs'
    signature "#{glob}*.rbs"
  end
end
