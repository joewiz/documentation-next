(: Retrieve range index field keys starting from a given prefix :)
(: The 4-arg variant adds a start-value filter :)
range:index-keys-for-field(
  "city-name",
  "N",
  function($key, $count) {
    $key || " (" || $count[1] || " occurrences)"
  },
  100
)
