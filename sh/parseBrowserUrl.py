import json
import os
import sys

assetName=sys.argv[1]
obj=json.load(sys.stdin)

for x in obj['assets']:
  if x['name'] == assetName:
    print x['browser_download_url']
