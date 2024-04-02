#/bin/bash
# Bash script for start up all the programs for SERGE
# All programs are started in the background and in parallel
# All the programs are called with their needed arguments
# Author: Félix MARQUET

# Démarrer le serveur TCP
echo "Starting the TCP server"
/mnt/win/Users/BreizhHardware/Nextcloud/Programation/C++/Modelec/Initialisation/test/test1.sh &
sleep 1

# Démarrer le Lidar
echo "Starting the Lidar"
/mnt/win/Users/BreizhHardware/Nextcloud/Programation/C++/Modelec/Initialisation/test/test2.sh &
sleep 1

# Démarrer la caméra
echo "Starting the camera"
/mnt/win/Users/BreizhHardware/Nextcloud/Programation/C++/Modelec/Initialisation/test/test3.sh &
sleep 1

# Démarrer l'IHM
echo "Starting the IHM"
/mnt/win/Users/BreizhHardware/Nextcloud/Programation/C++/Modelec/Initialisation/test/test4.sh fullscreen &

# Fonction pour surveiller la fermeture de tous les programmes
monitor_all() {
    local pids=$(pgrep -d ' ' -f "test1|test2|test3|test4")
    
    # Attendre que l'un des programmes se termine
    wait $pids
    
    # Terminer tous les autres programmes
    for pid in $pids; do
        if ps -p $pid > /dev/null; then
            echo "Program with PID $pid has terminated, stopping other programs"
            pkill -P $$ -f "test1|test2|test3|test4"
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
/mnt/win/Users/BreizhHardware/Nextcloud/Programation/C++/Modelec/Initialisation/test/test5.sh