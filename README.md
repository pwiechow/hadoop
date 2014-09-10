## Hadoop docker image

### Usage

Result: 4 containers running on localhost: master, slave 1 .. 3, localdns

* Run local DNS used by hadoop cluster:

`sudo docker run -d --name localdns -v /etc/hosts:/etc/althosts pwiechow/dns`

* Inspect IP of localdns by typing the following:

`sudo docker inspect localdns | grep IPAddress | sed 's/^[^0-9]\+\([0-9\.]\+\)\".*/\1/'`

* Run master, slave1..3

`sudo docker run -d -h master --name master --dns=$IP_OF_LOCAL_DNS pwiechow/hadoop`

`sudo docker run -d -h slave1 --name slave1 --dns=$IP_OF_LOCAL_DNS pwiechow/hadoop`

`sudo docker run -d -h slave2 --name slave2 --dns=$IP_OF_LOCAL_DNS pwiechow/hadoop`

`sudo docker run -d -h slave3 --name slave3 --dns=$IP_OF_LOCAL_DNS pwiechow/hadoop`

* Add master and slaves to /etc/hosts

* Restart localdns

`sudo docker restart localdns`

* Log into master by ssh
