(: Retrieve all distinct values stored in a range index field :)
(: The callback receives (key, frequencies) and returns the formatted result :)
range:index-keys-for-field(
  "city-country",
  function($key, $count) {
    $key || " (" || $count[1] || " occurrences)"
  },
  100
)
