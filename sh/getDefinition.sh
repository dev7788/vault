#!/bin/bash

DB="${DB:-vault}"
DUMP_PATH="${DUMP_PATH:-/tmp/dump.sql}"
LIST_PATH="${LIST_PATH:-/tmp/list.txt}"
DEF_PATH="${DEF_PATH:-/tmp/definition.sql}"
DEF_SHA_PATH="${DEF_SHA_PATH:-$DEF_PATH.sha512}"

PGHOST="${PGHOST:-localhost}"
PGUSER="${PGUSER:-postgres}"

# Export the database schema to a temporary file
pg_dump --format=custom --schema-only --exclude-schema=concept --exclude-schema=indicator --file="$DUMP_PATH" $DB

# Create a restore list, but ignore header comments and then order by the name of the object (instead of a bunch of internal id's)
pg_restore -l "$DUMP_PATH" | grep -v "^;.*" | sort -t " " -k 4 > "$LIST_PATH"

# Create a restore definition (using the ordered restore list above)
pg_restore -L "$LIST_PATH" "$DUMP_PATH" > "$DEF_PATH"

# Hash the definition
sha512sum "$DEF_PATH" | cut -d " " -f 1  > $DEF_SHA_PATH
