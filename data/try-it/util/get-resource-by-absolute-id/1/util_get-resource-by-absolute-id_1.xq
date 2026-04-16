try { util:get-resource-by-absolute-id(1) }
catch * { "Error: " || $err:description }