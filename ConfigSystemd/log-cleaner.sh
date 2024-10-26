#!/bin/bash

#Verification que le script s'execute en root
if [ "$EUID" -ne 0 ]; then
	echo "Ce script doit être exécuté en tant que root"
	exit 1
fi

#Afficher la taille avant nettoyage des journaux
echo "Taille des journeaux avant nettoyage :"
journalctl --disk-usage

#Nettoyage des journaux systemd /rétention 1 heure
echo "Nettoyage des journaux systemd en cours..."
journalctl --vacuum-time=1h

#Afficher la taille après nettoyage des journaux
echo -e "\nTaille des journaux après nettoyage :"
journalctl --disk-usage

echo "Nettoyage terminé !"


