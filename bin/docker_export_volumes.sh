#!/bin/bash

PREFIX="$1"
BACKUP_DIR="./docker-volumes-backup"
mkdir -p "$BACKUP_DIR"

if [ -n "$PREFIX" ]; then
  echo "Export volumes with prefix: $PREFIX"
  VOLUMES=$(docker volume ls -q | grep "^$PREFIX")
else
  echo "Export all volumes"
  VOLUMES=$(docker volume ls -q)
fi

for volume in $VOLUMES; do
  echo "Export volume: $volume"
  docker run --rm \
    -v $volume:/volume \
    -v $(pwd)/$BACKUP_DIR:/backup alpine \
    tar czf /backup/$volume.tar.gz -C /volume .
done

echo "Backup complete $BACKUP_DIR"