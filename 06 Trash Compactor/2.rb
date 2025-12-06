# Tip: both `+` and `-` are commutative (order doesn’t matter).

puts(ARGF.each_line.map(&:chars)
  .transpose #: Array[Array[String]]
  .each { it.delete ' ' }
  .slice_after(&:empty?)
  .sum do|*operands, _column_delimiter|
    operator = operands.first.pop #: String
    operands.map { Integer(it.join) }.inject operator
  end
)
