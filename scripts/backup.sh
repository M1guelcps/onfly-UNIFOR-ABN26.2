#!/bin/bash

set -e

# ==========================================
# CONFIGURAÇÕES
# ==========================================

BACKUP_DIR="/opt/paas/backups"
TRAEFIK_DIR="/opt/paas/traefik"
POSTGRES_CONTAINER="central-postgres"
POSTGRES_USER="postgres"

DATE=$(date +"%Y-%m-%d_%H-%M-%S")

TEMP_DIR="/tmp/paas-backup-$DATE"
DUMP_FILE="$TEMP_DIR/dump.sql"
BACKUP_FILE="$BACKUP_DIR/backup-$DATE.tar.gz"

# ==========================================
# PREPARAÇÃO
# ==========================================

mkdir -p "$TEMP_DIR"
mkdir -p "$BACKUP_DIR"

echo "=========================================="
echo "Iniciando backup..."
echo "Data: $(date)"
echo "=========================================="

# ==========================================
# 1. BACKUP DO POSTGRESQL
# ==========================================

echo "[1/4] Fazendo dump do PostgreSQL..."

docker exec "$POSTGRES_CONTAINER" \
    pg_dumpall -U "$POSTGRES_USER" > "$DUMP_FILE"

echo "PostgreSQL salvo."

# ==========================================
# 2. COPIAR ACME.JSON
# ==========================================

echo "[2/4] Preparando arquivos do Traefik..."

mkdir -p "$TEMP_DIR/traefik"

cp "$TRAEFIK_DIR/acme.json" "$TEMP_DIR/traefik/acme.json"

echo "acme.json salvo."

# ==========================================
# 3. COMPACTAR
# ==========================================

echo "[3/4] Criando arquivo compactado..."

tar -czf "$BACKUP_FILE" \
    -C "$TEMP_DIR" \
    dump.sql \
    traefik/acme.json

echo "Backup criado:"
echo "$BACKUP_FILE"

# ==========================================
# 4. APAGAR BACKUPS ANTIGOS
# ==========================================

echo "[4/4] Removendo backups com mais de 7 dias..."

find "$BACKUP_DIR" \
    -type f \
    -name "backup-*.tar.gz" \
    -mtime +7 \
    -delete

echo "Limpeza concluída."

# ==========================================
# LIMPEZA TEMPORÁRIA
# ==========================================

rm -rf "$TEMP_DIR"

echo "=========================================="
echo "BACKUP CONCLUÍDO COM SUCESSO"
echo "=========================================="
