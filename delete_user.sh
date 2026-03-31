#!/bin/bash

set -e

if [ "$#" -lt 1 ]; then
  echo "Usage: ./delete_user.sh <username>"
  echo "Example: ./delete_user.sh admin"
  exit 1
fi

USERNAME="$1"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/backend"

npm run delete-user -- --username "$USERNAME"
