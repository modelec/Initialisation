#!/bin/bash

# Update of the Initialization script
rm /home/modelec/Serge/Initialisation/startup.sh && cd /home/modelec/Serge/Initialisation && git pull && chmod 777 startup.sh

# Update of the TCP server
cd /home/modelec/Serge/TCPSocketClient && git pull && cd build && cmake .. && make

# Update of the TCP Client
cd /home/modelec/Serge/TCPSocketServer && git pull && cd build && cmake .. && make

# Update of the connectors
cd /home/modelec/Serge/connectors && git pull && cd build && cmake .. && make

# Update of the detection adversaire
cd /home/modelec/Serge/detection_adversaire && git pull && cd build && cmake .. && make

# Update of the detection pot
cd /home/modelec/Serge/detection_pot && git pull && cd build && cmake .. && make

# Update of the emergency stop
cd /home/modelec/Serge/emergency && git pull && cd build && cmake .. && make

# Update of the IHM
cd /home/modelec/Serge/ihm && git pull && cd build && cmake .. && make

# Update of the servo moteur
cd /home/modelec/Serge/servo_moteurs && git pull && cd build && cmake .. && make

# Update of the tirette
cd /home/modelec/Serge/tirette && git pull && g++ main.cpp MyClient.cpp MyClient.h -o tirette -l wiringPi -l TCPSocket

echo "All repositories have been updated, Please check the logs for any errors"