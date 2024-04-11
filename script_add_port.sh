#!/bin/bash

# Chemin vers votre fichier
file_path="port"

# Lire chaque ligne du fichier
while IFS= read -r line; do
    echo "$line"
    # Extraire le ou les num�ro(s) de port � partir de la fin de la ligne
    ports=$(echo "$line" | awk -F ': ' '{print $2}')

    # Si la ligne contient plusieurs ports s�par�s par des virgules
    IFS=',' read -ra PORTS_ARRAY <<< "$ports"
    for port in "${PORTS_ARRAY[@]}"; do
        port=$(echo "$port" | xargs)  # Supprime les espaces superflus
        echo "Ouverture du port $port pour le service $(echo "$line" | awk -F ': ' '{print $1}')"
        sudo firewall-cmd --zone=public --add-port="$port"/tcp --permanent
        sudo firewall-cmd --zone=public --add-port="$port"/udp --permanent
    done
done < "$file_path"

# Recharger la configuration de firewalld pour appliquer les changements
sudo firewall-cmd --reload
