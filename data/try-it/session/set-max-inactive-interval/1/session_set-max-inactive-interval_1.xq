(: Set the max inactive interval; negative means never timeout :)
try {
  session:set-max-inactive-interval(1800),
  "Max inactive interval set to 1800 seconds"
} catch * {
  "session:set-max-inactive-interval#1 — " || $err:description
}
