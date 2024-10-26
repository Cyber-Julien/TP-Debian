#!/bin/bash

# Configuration
SOURCE_DIR="/data"
BACKUP_DIR="/mnt/storage"
LOG_FILE="/var/log/backup.log"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_${DATE}.tar.gz"

# Fonction de logging
log_message() { 
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

#Vérification des répertoires
if [ ! -d "$SOURCE_DIR" ]; then
       	log_message "ERREUR: Le répertoire source $SOURCE_DIR n'existe pas!"
	exit 1
fi

if [ ! -d "$BACKUP_DIR" ]; then
	log_message "ERREUR: Le répertoire de destination $BACKUP_DIR n'existe pas!"
	exit 1
fi

# Vérification de l'espace disque
SOURCE_SIZE=$(du -sb "$SOURCE_DIR" | awk '{print $1}')
DEST_SPACE=$(df -B1 "$BACKUP_DIR" | awk 'NR==2 {print $4}')

if [ "$SOURCE_SIZE" -gt "$DEST_SPACE" ]; then
	log_message "ERREUR: Espace disque insuffisant dans $BACKUP_DIR"
	exit 1
fi

#Début de la sauvegarde
log_message "Début de la sauvegarde de $SOURCE_DIR"

#Création de la sauvegarde avec tar
if tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")" 2>/dev/null; then
	# Calcul de la taille de la sauvegarde
	log_message "Sauvegarde réussie : $BACKUP_DIR/$BACKUP_NAME"

	# Nettoyage des anciennes sauvegardes (garde les 5 plus récentes)
	cd "$BACKUP_DIR" || exit

	ls -t backup_*.tar.gz | tail -n +6 | xargs -r rm
	log_message "Nettoyage des anciennes sauvegardes terminé"
else
	log_message "Erreur: La sauvegarde a échoué!"
	exit 1
fi

