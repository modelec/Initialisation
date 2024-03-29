#/bin/bash
# Bash script for start up all the programs for SERGE
# All programs are started in the background and in parallel
# All the programs are called with their needed arguments
# Author: Félix MARQUET

# Démarrer le serveur TCP
echo "Starting the TCP server"
/home/modelec/serge/tcp-server &
sleep 1

# Démarrer le Lidar
echo "Starting the Lidar"
/home/modelec/serge/lidar &
sleep 1

# Démarrer la caméra
echo "Starting the camera"
/home/modelec/serge/camera &

# Démarrer l'IHM
echo "Starting the IHM"
/home/modelec/serge/ihm fullscreen &

# Fonction pour surveiller la fermeture de l'IHM
monitor_ihm() {
    while pgrep -x "ihm" > /dev/null; do
        sleep 1
    done
    # Une fois l'IHM fermée, tuer tous les autres programmes
    killall tcp-server
    killall lidar
    killall camera
    echo "All programs terminated."
}

# Démarrer la fonction de surveillance en arrière-plan
monitor_ihm &

# Attendre que tous les programmes se terminent
wait
