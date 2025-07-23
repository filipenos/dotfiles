#!/bin/bash

BACKUP_DIR="./docker-volumes-backup"

for file in $BACKUP_DIR/*.tar.gz; do
  volume_name=$(basename "$file" .tar.gz)
  echo "Restore volume: $volume_name"
  docker volume create "$volume_name"
  docker run --rm \
    -v $volume_name:/volume \
    -v $(pwd)/$BACKUP_DIR:/backup alpine \
    sh -c "cd /volume && tar xzf /backup/$volume_name.tar.gz"
done

echo "Restore complete."