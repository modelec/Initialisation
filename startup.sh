#/bin/bash
# Bash script for start up all the programs for SERGE
# All programs are started in the background and in parallel
# All the programs are called with their needed arguments
# Author: Félix MARQUET

# Démarrer le serveur TCP
echo "Starting the TCP server"
/home/modelec/Serge/TCPSocketServer/build/socketServer &
sleep 1

# Démarrer le Lidar
echo "Starting the Lidar"
/home/modelec/Serge/detection_adversaire/build/lidar &
sleep 1

# Démarrer la caméra
echo "Starting the camera"
/home/modelec/Serge/detection_pot/build/arucoDetector /home/modelec/Serge/detection_pot/build/camera_calibration.yml 8080 --headless &
sleep 1

# Démarrer l'IHM
echo "Starting the IHM"
/home/modelec/Serge/ihm/build/ihm_robot fullscreen &

# Fonction pour surveiller la fermeture de l'IHM
monitor_all() {
    local pids=$(pgrep -d ' ' -f "socketServer|lidar|arucoDetector|ihm_robot")
    
    # Attendre que l'un des programmes se termine
    wait $pids
    
    # Terminer tous les autres programmes
    for pid in $pids; do
        if ps -p $pid > /dev/null; then
            echo "Program with PID $pid has terminated, stopping other programs"
            pkill -P $$ -f "lidar|arucoDetector|ihm_robot"
            sleep 1
            pkill -P && -f "socketServer"
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
/home/modelec/Serge/starting-position