#!/bin/bash

# Architecture et version du kernel
echo "### Architecture du système et version du kernel :"
uname -a

# Nombre de processeurs physiques
echo -n "### Nombre de processeurs physiques : "
grep "physical id" /proc/cpuinfo | sort | uniq | wc -l

# Nombre de processeurs virtuels
echo -n "### Nombre de processeurs virtuels : "
grep "processor" /proc/cpuinfo | wc -l

# RAM disponible et taux d'utilisation :"
echo "### RAM disponible et taux d'utilisation :"
free -m | awk 'NR==2{printf "Total: %s MB, Utilisée: %s MB, Libre: %s MB, Utilisation: %.2f%%\n", $2, $3, $4, $3*100/$2  }'

#Espace de stockage disponible et taux d'utilisation
echo "### Espace de stockage disponible et taux d'utilisation :"
df -h / | awk 'NR==2{printf "Total: %s, Utilisé: %s, Libre: %s, Utilisation: %.2f%%\n", $2, $3, $4, $5}'

#Taux d'utilisation des processeurs
echo -n "### Taux d'utilisation des processeurs: "
top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1 "%"}'

# Date et heure du dernier redémarrage
echo "### Date et heure du dernier redémarrage :"
who -b | awk '{print $3" "$4}'

#LVM actif ou non
echo -n "### LVM actif : "
if lsblk | grep -q "lvm" ; then echo "oui"; else echo "non"; fi

# Nombre de connexions actives
echo "### Nombre de connexions actives :"
echo " $(ss -t | grep "ESTAB" | wc -l) connexions tcp ESTABLISHED"
echo " $(ss -u | grep "ESTAB" | wc -l) connexions udp ESTABLISHED"

# Nombre d'utilisateurs utilisant le serveur
echo -n "### Nombre d'utilisateurs utilisant le serveur : "
users | wc -w

#Adresse IPv4 et MAC
echo "### Adresse IPv4 et MAC :"
ip a | awk '/inet / {print $2}' | grep -v "127.0.0.1" | head -n1
ip link | awk '/ether/ {print $2}' | head -n1

#Nombre de commandes exécutées avec sudo
echo -n "### Nombre de commandes executées avec sudo : "
if [ -f /var/log/sudo/log ]; then grep "COMMAND" /var/log/sudo/log | wc -l ; else echo " Le fichier /var/log/sudo/log n'existe pas."; fi 
