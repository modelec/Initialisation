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
monitor_all() {
    local pids=$(pgrep -d ' ' -f "tcp-server|lidar|camera|ihm")
    
    # Attendre que l'un des programmes se termine
    wait $pids
    
    # Terminer tous les autres programmes
    for pid in $pids; do
        if ps -p $pid > /dev/null; then
            echo "Program with PID $pid has terminated, stopping other programs"
            pkill -P $$ -f "tcp-server|lidar|camera|ihm"
            break
        fi
    done
    echo "All programs have terminated"
}

# Démarrer la fonction de surveillance en arrière-plan
monitor_all &

# Attendre que tous les programmes se terminent
wait

# Retourner à la position de départ
echo "Put SERGE back in the starting position"
/home/modelec/serge/starting-position