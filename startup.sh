#!/bin/bash
# Bash script for start up all the programs for SERGE
# All programs are started in the background and in parallel
# All the programs are called with their needed arguments
# Author: Félix MARQUET

# Stocker les PIDs des programmes en arrière-plan dans une array
pids=()

# Démarrer le serveur TCP
echo "Starting the TCP server"
/home/modelec/Serge/TCPSocketServer/build/socketServer &
echo "TCP server pid" $! > /home/modelec/Serge/TCP_pid.txt
pids+=($!)
sleep 1

# Démarrer le Lidar
echo "Starting the Lidar"
/home/modelec/Serge/detection_adversaire/build/lidar &
echo "Lidar pid" $! > /home/modelec/Serge/Lidar_pid.txt
pids+=($!)
sleep 1

# Démarrer l'IHM
echo "Starting the IHM"
/home/modelec/Serge/ihm/build/ihm_robot fullscreen &
echo "IHM pid" $! > /home/modelec/Serge/IHM_pid.txt
pids+=($!)
sleep 1

# Démarrer la caméra
echo "Starting the camera"
screen -dmS camera /home/modelec/Serge/detection_pot/build/arucoDetector /home/modelec/Serge/detection_pot/build/camera_calibration.yml 8080 --headless
pid=$(screen -ls | grep -o '[0-9]*\.camera' | grep -o '[0-9]*')
echo "Camera pid" $pid > /home/modelec/Serge/Camera_pid.txt
pids+=($pid)
sleep 1

# Démarrer le programme d'interconnexion raspi -> arduino
echo "Starting the interconnection program"
/home/modelec/Serge/connectors/build/connectors &
echo "Interconnection pid" $! > /home/modelec/Serge/Interconnection_pid.txt
pids+=($!)
sleep 1

# Démarrer le programme de contrôle des servomoteurs
echo "Starting the servomotor control program"
/home/modelec/Serge/servo_moteurs/build/servo_motor &
echo "Servomotor pid" $! > /home/modelec/Serge/Servomotor_pid.txt
pids+=($!)
sleep 1

# Démarrer le programme de la tirette
echo "Starting the tirette program"
/home/modelec/Serge/tirette/tirette &
echo "Tirette pid" $! > /home/modelec/Serge/Tirette_pid.txt
pids+=($!)
sleep 1


# Fonction pour surveiller la fermeture de l'IHM
monitor_all() {
    while true; do
        # Attendre que un des programmes se termine
        for pid in "${pids[@]}"; do
            if ! kill -0 $pid 2>/dev/null; then
                echo "Program with PID $pid has terminated, stopping other programs"
                pkill -P $$ -f "lidar|arucoDetector|ihm_robot|connectors|servo_motor|tirette"
                sleep 1
                pkill -P $$ -f "socketServer"
                return
            fi
        done
        sleep 1
    done
}

# Démarrer la fonction de surveillance en arrière-plan
monitor_all &

# Attendre que tous les programmes se terminent
wait

# Retourner à la position de départ
echo "Put SERGE back in the starting position"
/home/modelec/Serge/starting-position