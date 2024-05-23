#!/bin/bash

# Update Server TCP
echo "Upadting TCP Server"
cd /home/modelec/Serge/TCPSocketServer/build && git pull && cmake .. && make
cd /home/modelec/Serge/TCPSocketServerGC/build && git pull && cmake .. && make
echo "Server updated"

# Update of the TCP Client
echo "Updating the TCP client"
cd /home/modelec/Serge/cpp-lib && git pull && cd build && cmake .. && sudo make && sudo make install
cd /home/modelec/Serge/cpp-lib/example/build && cmake .. && make
echo "Lib updated"

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
cd /home/modelec/Serge/tirette && git pull && g++ main.cpp MyClient.cpp MyClient.h -o tirette -l wiringPi -l Modelec
echo "Tirette updated"

echo "All repositories have been updated, Please check the logs for any errors"
echo "Please update Initialisation manually using git pull"
