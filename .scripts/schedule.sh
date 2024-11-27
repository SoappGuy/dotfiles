#!/usr/bin/env bash

ENABLED=true

# Set period bounds
START_TIME=$(date +%s -d '-1hour -35minutes')
END_TIME=$(date +%s -d '12hours')

# Set format
FORMAT='{start_time} - {end_time} | {lecture_type} | {subject.brief}'

if $ENABLED; then
    # Get schedule for period with no labels using specified format
    SCHEDULE=$(                             \
        nure_cli schedule group 'пзпі-23-2' \
        --no_labels                         \
        --sep   "\r"                        \
        --fmt   "$FORMAT"                   \
        --start "$START_TIME"               \
        --end   "$END_TIME"                 \
    )

    # Extract first lecture
    FIRST_LINE=$(echo -e "$SCHEDULE" | cut -d $'\r' -f 1)

    printf '{"text": "%s", "tooltip": "%s", "class": ""}\n' "$FIRST_LINE" "$SCHEDULE"
else
    printf '{"text": "Disabled", "tooltip": "", "class": ""}\n'
fi
