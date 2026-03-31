#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ENV_FILE="$ROOT_DIR/backend/.env"
INIT_SQL="$SCRIPT_DIR/init.sql"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing $ENV_FILE"
  echo "Create it from backend/.env.example first."
  exit 1
fi

if [[ ! -f "$INIT_SQL" ]]; then
  echo "Missing $INIT_SQL"
  exit 1
fi

set -a
source "$ENV_FILE"
set +a

required_vars=(DB_HOST DB_PORT DB_USER DB_PASSWORD DB_NAME)
for var in "${required_vars[@]}"; do
  if [[ -z "${!var:-}" ]]; then
    echo "Missing required env var: $var"
    exit 1
  fi
done

DB_ADMIN_USER="${DB_ADMIN_USER:-root}"
DB_ADMIN_PASSWORD="${DB_ADMIN_PASSWORD:-}"

sql_escape() {
  local value="${1//\'/\'\'}"
  printf "%s" "$value"
}

ESC_DB_NAME="$(sql_escape "$DB_NAME")"
ESC_DB_USER="$(sql_escape "$DB_USER")"
ESC_DB_PASSWORD="$(sql_escape "$DB_PASSWORD")"
ESC_DB_HOST="$(sql_escape "$DB_HOST")"

MYSQL_ADMIN_CMD=(mysql -u "$DB_ADMIN_USER")
if [[ -n "$DB_ADMIN_PASSWORD" ]]; then
  MYSQL_ADMIN_CMD+=("-p$DB_ADMIN_PASSWORD")
fi

echo "[1/2] Provisioning database and application user..."
"${MYSQL_ADMIN_CMD[@]}" <<SQL
CREATE DATABASE IF NOT EXISTS \`$ESC_DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS '$ESC_DB_USER'@'localhost' IDENTIFIED BY '$ESC_DB_PASSWORD';
CREATE USER IF NOT EXISTS '$ESC_DB_USER'@'%' IDENTIFIED BY '$ESC_DB_PASSWORD';
GRANT ALL PRIVILEGES ON \`$ESC_DB_NAME\`.* TO '$ESC_DB_USER'@'localhost';
GRANT ALL PRIVILEGES ON \`$ESC_DB_NAME\`.* TO '$ESC_DB_USER'@'%';
FLUSH PRIVILEGES;
SQL

echo "[2/2] Applying schema from database/init.sql..."
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" "-p$DB_PASSWORD" "$DB_NAME" < "$INIT_SQL"

echo "Done. Database initialized safely from .env values."
