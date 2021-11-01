#!/bin/sh
OUTPUT=$(SCRIPT_FILENAME=/var/www/wordpress/index.php QUERY_STRING=health_check=true REQUEST_METHOD=GET cgi-fcgi -bind -connect localhost:9000 2>&1 | html2text)
if echo $OUTPUT | grep -q 'Content-length: 0'; then
  echo "Ok"
  exit 0
else
  echo "Error"
  echo "$OUTPUT"
  exit 2
fi
