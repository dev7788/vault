#!/bin/bash

# Configure the comparison directories and files
COMPARE_DIR="${COMPARE_DIR:-/tmp/vault}"
EXP_SHA_PATH=$COMPARE_DIR/expDefinition.sql.sha512
ACT_SHA_PATH=$COMPARE_DIR/actDefinition.sql.sha512
EXP_DEF_PATH=$COMPARE_DIR/expDefinition.sql
ACT_DEF_PATH=$COMPARE_DIR/actDefinition.sql

# Clean the existing comparison directory
rm -rf $COMPARE_DIR
mkdir $COMPARE_DIR

# Export the definition (and hash) of the Vault running on the endpoint
DEF_PATH=$ACT_DEF_PATH DEF_SHA_PATH=$ACT_SHA_PATH bash ./getDefinition.sh

# Download the Vault's "latest" release in json format
RELEASE=$(curl --silent "https://api.github.com/repos/HDCbc/vault/releases/latest")

# Parse the download url for the definition.sql and definition.sql.sha512 files
DEF_URL=$(echo "$RELEASE" | python parseBrowserUrl.py definition.sql)
SHA_URL=$(echo "$RELEASE" | python parseBrowserUrl.py definition.sql.sha512)

# Download the Expected SHA Hash
curl --silent -L $SHA_URL > $EXP_SHA_PATH

# Compare the expected SHA Hash (on Github) with the actual (on the endpoint)
DIFF=$(diff $EXP_SHA_PATH $ACT_SHA_PATH)

if [ $? -eq 0 ]; then
  # If the hashes are the same, then exit successfully
  echo "Same"
  rm -rf $COMPARE_DIR
  exit 0
else
  # If the hashes are different..
  echo "HASH DIFFERENCES:"
  echo "$DIFF"

  # Download the Expected Definition from Github
  curl --silent -L $DEF_URL > $EXP_DEF_PATH

  # Compare the Expected Definition (on Github) with the Actual Definition (on the endpoint)
  DIFF2=$(diff $EXP_DEF_PATH $ACT_DEF_PATH)
  echo "SQL DIFFERENCES:"
  echo "$DIFF2"

  rm -rf $COMPARE_DIR
  exit 1
fi
