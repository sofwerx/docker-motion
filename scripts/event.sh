#!/bin/bash
action="$(basename $0 | sed -e 's/.sh$//')"
. /.env
if [ -n "${ES_MOTION_URL}" ]; then
  if [ -n "${ES_MOTION_HTTP_AUTH}" ]; then
    AUTH_FLAGS="-u ${ES_MOTION_HTTP_AUTH}"
  fi
  curl -sL $AUTH_FLAGS -H "Content-Type: application/json" -XPOST "${ES_MOTION_URL}" -d @- <<EOF > /dev/null 2>&1
{
  "action": "$action",
  "timestamp": "$(date --iso-8601=seconds)",
  "event": $@
}
EOF
fi
if [ "$action" = "picture_save" ] ; then
  filename=$(echo "$@" | jq -r .filename)
  if [ -n "${MINIO_URL}" ] ; then
    mc cp $filename minio/motion$filename && rm -f $filename
  fi
fi
if [ "$action" = "movie_end" ] ; then
  filename=$(echo "$@" | jq -r .filename)
  if [ -n "${MINIO_URL}" ] ; then
    mc cp $filename minio/motion$filename && rm -f $filename
  fi
fi
