#!/usr/bin/env bash
set -euo pipefail

FILENAME="openclaw-latest.tar.gz"
TAR_FILE="/tmp/$FILENAME"

cleanup() {
  rm -f "$TAR_FILE"
}
trap cleanup ERR EXIT

tar \
  --exclude='.openclaw/.node-compile-cache' \
  -czvf "$TAR_FILE" \
  -C "$OPENCLAW_HOME" \
  .openclaw/

aws s3 cp "$TAR_FILE" "s3://$BUCKET_NAME/$SERVICE_NAME/$FILENAME"

mosquitto_pub \
  -h "$MOSQUITTO_HOST" \
  -u "$MOSQUITTO_USERNAME" \
  -P "$MOSQUITTO_PASSWORD" \
  -t "backup/$SERVICE_NAME/time" \
  -m "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
