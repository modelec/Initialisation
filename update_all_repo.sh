#!/bin/bash

# Update of the Initialization script
echo "Updating the Initialization script"
rm /home/modelec/Serge/Initialisation/startup.sh && cd /home/modelec/Serge/Initialisation && git pull && chmod 777 startup.sh
echo "Initialization script updated"

# Update of the TCP server
echo "Updating the TCP server"
cd /home/modelec/Serge/TCPSocketServer && git pull && cd build && cmake .. && make 
echo "TCP server updated"

# Update of the TCP Client
echo "Updating the TCP client"
cd /home/modelec/Serge/TCPSocketClient && git pull && cd build && cmake .. && sudo make install 
echo "TCP client updated"

# Update of the connectors
echo "Updating the connectors"
cd /home/modelec/Serge/connectors && git pull && cd build && cmake .. && make
echo "Connectors updated"

# Update of the detection adversaire
echo "Updating the detection adversaire"
cd /home/modelec/Serge/detection_adversaire && git pull && cd build && cmake .. && make
echo "Detection adversaire updated"

# Update of the detection pot
echo "Updating the detection pot"
cd /home/modelec/Serge/detection_pot && git pull && cd build && cmake .. && make
echo "Detection pot updated"

# Update of the emergency stop
echo "Updating the emergency stop"
cd /home/modelec/Serge/emergency && git pull && cd build && cmake .. && make
echo "Emergency stop updated"

# Update of the IHM
echo "Updating the IHM"
cd /home/modelec/Serge/ihm && git pull && cd build && cmake .. && make
echo "IHM updated"

# Update of the servo moteur
echo "Updating the servo moteur"
cd /home/modelec/Serge/servo_moteurs && git pull && cd build && cmake .. && make
echo "Servo moteur updated"

# Update of the tirette
echo "Updating the tirette"
cd /home/modelec/Serge/tirette && git pull && g++ main.cpp MyClient.cpp MyClient.h -o tirette -l wiringPi -l TCPSocket
echo "Tirette updated"

echo "All repositories have been updated, Please check the logs for any errors"