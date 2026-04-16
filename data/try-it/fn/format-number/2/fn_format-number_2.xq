let $nums := (1234567.89, 0.5, -42, 3.14159)
for $n in $nums
return format-number($n, "#,###.00")
