#!/bin/bash
# Bash script for start up all the programs for SERGE
# All programs are started in the background and in parallel
# All the programs are called with their needed arguments
# Author: Félix MARQUET

# Stocker les PIDs des programmes en arrière-plan dans une array
pids=()
pidserver=()

if [ -z "$1" ]; then
    port=8080
else
    port="$1"
fi

# Démarrer le serveur TCP
echo "Starting the TCP server GC"
/home/modelec/Serge/TCPSocketServerGC/build/socketServer --port "$port" &
echo "TCP server pid" $! > /home/modelec/Serge/TCP_GC_pid.txt
pidserver+=($!)
sleep 1

# Démarrer le Lidar
echo "Starting the Lidar"
rm /home/modelec/Serge/Logs/lidar.log
screen -L -Logfile /home/modelec/Serge/Logs/lidar.log -dmS lidar /home/modelec/Serge/detection_adversaire/build/lidar --port "$port"
pidLidar=$(screen -ls | grep -o '[0-9]*\.lidar' | grep -o '[0-9]*')
echo "Lidar pid" $pidLidar > /home/modelec/Serge/Lidar_pid.txt
pids+=($pidLidar)
sleep 1

# Démarrer l'IHM
echo "Starting the IHM"
rm /home/modelec/Serge/Logs/ihm_robot.log
/home/modelec/Serge/ihm/build/ihm_robot --window-mode fullscreen --port "$port" > /home/modelec/Serge/Logs/ihm_robot.log &
echo "IHM pid" $! > /home/modelec/Serge/IHM_pid.txt
pids+=($!)
sleep 1

# Démarrer le programme d'interconnexion raspi -> arduino
echo "Starting the interconnection program"
rm /home/modelec/Serge/Logs/connectos.log
screen -L -Logfile /home/modelec/Serge/Logs/connectos.log -dmS connectors /home/modelec/Serge/connectors/build/connectors --port "$port"s
pid=$(screen -ls | grep -o '[0-9]*\.connectors' | grep -o '[0-9]*')
echo "Interconnection pid" $pid > /home/modelec/Serge/Interconnection_pid.txt
pids+=($pid)
sleep 1

# Démarrer le programme de contrôle des servomoteurs
echo "Starting the servomotor control program"
rm /home/modelec/Serge/Logs/servo_motor.log
screen -L -Logfile /home/modelec/Serge/Logs/servo_motor.log -dmS servo_motor /home/modelec/Serge/servo_moteurs/build/servo_motor --port "$port"
pid=$(screen -ls | grep -o '[0-9]*\.servo_motor' | grep -o '[0-9]*')
echo "Servomotor pid" $pid > /home/modelec/Serge/Servomotor_pid.txt
pids+=($pid)
sleep 1

echo "Starting the client logger program"
rm /home/modelec/Serge/Logs/client.log
echo "$(date +'%Y-%m-%d %H:%M:%S') - Starting the client logger program" >> /home/modelec/Serge/Logs/client.log
/home/modelec/Serge/cpp-lib/example/build/client --port "$port" --logger >> /home/modelec/Serge/Logs/client.log 2>&1 &
echo "Client Logger pid" $! > /home/modelec/Serge/client_pid.txt
pids+=($!)
sleep 1

# Fonction pour surveiller la fermeture de l'IHM
monitor_all() {
    while true; do
        # Attendre que un des programmes se termine
        for pid in "${pids[@]}"; do
            if ! kill -0 $pid 2>/dev/null; then
                echo "Program with PID $pid has terminated, stopping other programs"
                for other_pid in "${pids[@]}"; do
                    if [ "$other_pid" != "$pid" ]; then
                        kill -SIGINT $other_pid 2>/dev/null
                    fi
                done
                echo "Stopping the TCP server"
                for server_pid in "${pidserver[@]}"; do
                    kill -SIGKILL $server_pid 2>/dev/null
                done
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

screen -wipe
