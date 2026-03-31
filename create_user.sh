#!/bin/bash

set -e

if [ "$#" -lt 2 ]; then
	echo "Usage: ./create_user.sh <username> <password> [approved]"
	echo "Example: ./create_user.sh admin 'Admin!1234' 1"
	exit 1
fi

USERNAME="$1"
PASSWORD="$2"
APPROVED="${3:-1}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/backend"

npm run create-user -- \
	--username "$USERNAME" \
	--password "$PASSWORD" \
	--approved "$APPROVED"