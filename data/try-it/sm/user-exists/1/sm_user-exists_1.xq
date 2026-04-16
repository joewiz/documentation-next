(
    "admin exists: " || sm:user-exists("admin"),
    "guest exists: " || sm:user-exists("guest"),
    "nonexistent exists: " || sm:user-exists("nonexistent-user-xyz")
)
