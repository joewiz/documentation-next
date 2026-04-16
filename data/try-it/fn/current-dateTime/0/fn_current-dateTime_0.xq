let $now := current-dateTime()
return (
    "Date/time: " || $now,
    "Date:      " || current-date(),
    "Time:      " || current-time(),
    "Year:      " || year-from-dateTime($now),
    "Timezone:  " || implicit-timezone()
)
