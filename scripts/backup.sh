#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-/backup/arr_plex}"
APPDATA_DIR="${APPDATA_DIR:-/docker/appdata}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS="${RETENTION_DAYS:-7}"

mkdir -p "$BACKUP_DIR"

echo "=== Backup ARR Stack - $TIMESTAMP ==="

SERVICES=(
    radarr
    sonarr
    lidarr
    bazarr
    prowlarr
    qbittorrent
    seerr
    jellyfin
    traefik
)

for service in "${SERVICES[@]}"; do
    if [ -d "$APPDATA_DIR/$service" ]; then
        echo "Sauvegarde de $service..."
        tar -czf "$BACKUP_DIR/${service}_${TIMESTAMP}.tar.gz" \
            -C "$APPDATA_DIR" "$service" \
            2>/dev/null || echo "ATTENTION: $service - erreur de compression (fichiers ignorés)"
    else
        echo "SKIP: $APPDATA_DIR/$service n'existe pas"
    fi
done

if [ -f ".env" ]; then
    echo "Sauvegarde du fichier .env..."
    cp .env "$BACKUP_DIR/env_${TIMESTAMP}"
fi

echo "Nettoyage des backups plus anciens que $RETENTION_DAYS jours..."
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +"$RETENTION_DAYS" -delete 2>/dev/null || true
find "$BACKUP_DIR" -name "env_*" -mtime +"$RETENTION_DAYS" -delete 2>/dev/null || true

TOTAL_SIZE=$(du -sh "$BACKUP_DIR" 2>/dev/null | cut -f1)
echo "=== Backup terminé. Taille totale: $TOTAL_SIZE ==="