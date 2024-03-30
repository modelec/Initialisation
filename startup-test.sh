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

# Démarrer l'IHM
echo "Starting the IHM"
/mnt/win/Users/BreizhHardware/Nextcloud/Programation/C++/Modelec/Initialisation/test/test4.sh fullscreen &

# Fonction pour surveiller la fermeture de l'IHM
monitor_ihm() {
    while pgrep -x "test4.sh" > /dev/null; do
        sleep 1
    done
    # Une fois l'IHM fermée, tuer tous les autres programmes
    killall test1.sh
    killall test2.sh
    killall test3.sh
    echo "All programs terminated."
}

# Démarrer la fonction de surveillance en arrière-plan
monitor_ihm &

# Attendre que tous les programmes se terminent
wait

# Retourner à la position de départ
echo "Put SERGE back in the starting position"
/mnt/win/Users/BreizhHardware/Nextcloud/Programation/C++/Modelec/Initialisation/test/test5.sh