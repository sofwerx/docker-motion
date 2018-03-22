#!/bin/bash
action="$(basename $0 | sed -e 's/.sh$//')"
. /.env
if [ -n "${ES_MOTION_HTTP_AUTH}" ]; then
  exec curl -sLu "${ES_MOTION_HTTP_AUTH}" -H "Content-Type: application/json" -XPOST "${ES_MOTION_URL}" -d @- <<EOF > /dev/null 2>&1
{
  "action": "$action",
  "timestamp": "$(date --iso-8601=seconds)",
  "args": "$@"
}
EOF
fi
