Hadoop
====

Hadoop docker image

Example of usage:

1 Run local DNS used by hadoop cluster:

sudo docker run -d --name localdns -v /etc/hosts:/etc/althosts pwiechow/dns

2 Add localdns IP address to /etc/hosts of the host machine. Inspect IP by typing the following:

sudo docker inspect localdns | grep IPAddress | sed 's/^[^0-9]\+\([0-9\.]\+\)\".*/\1/'

3 Run master, slave1..3

sudo docker run -d -i -t --name master --dns=localdns hadoop

sudo docker run -d -i -t --name slave1 --dns=localdns hadoop

sudo docker run -d -i -t --name slave2 --dns=localdns hadoop

sudo docker run -d -i -t --name slave3 --dns=localdns hadoop

4 Add master and slaves to /etc/hosts

5 Restart localdns

sudo docker restart localdns

6 Log into master by ssh
