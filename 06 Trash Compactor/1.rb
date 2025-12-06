puts(ARGF.each_line.map(&:split).transpose.sum do|*operands, operator|
  operands.map { Integer(it) }.inject operator
end)
