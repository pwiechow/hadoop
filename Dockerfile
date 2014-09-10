FROM pwiechow/jdk7
MAINTAINER Paweł Wiechowski
ENV HADOOP_PREFIX /usr/local/hadoop-2.5.0

# install sshd and configure temporary password for root

RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:pass' |chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN chmod 700 /root/.ssh/

# download hadoop
RUN wget http://ftp.ps.pl/pub/apache/hadoop/common/hadoop-2.5.0/hadoop-2.5.0.tar.gz -P /usr/local 

# extract it into /usr/local
RUN tar xzvf /usr/local/hadoop-2.5.0.tar.gz -C /usr/local && rm /usr/local/hadoop-2.5.0.tar.gz

# create symbolic link to hadoop instalation directory

RUN ln -s /usr/local/hadoop-2.5.0/ /usr/local/hadoop

# configure env variable for hadoop-env.sh

RUN sed -i 's/JAVA_HOME=${JAVA_HOME}/JAVA_HOME=\/usr\/lib\/jvm\/java-7-oracle\//g' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
RUN echo 'export HADOOP_PREFIX=/usr/local/hadoop' >> $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

# configure env variable for yarn-env.sh

RUN sed -i 's/# export JAVA_HOME=\/home\/y\/libexec\/jdk1.6.0\//export JAVA_HOME=\/usr\/lib\/jvm\/java-7-oracle\//g' $HADOOP_PREFIX/etc/hadoop/yarn-env.sh
RUN echo 'export HADOOP_PREFIX=/usr/local/hadoop' >> $HADOOP_PREFIX/etc/hadoop/yarn-env.sh

# copy config for fully distributed mode
ADD core-site.xml $HADOOP_PREFIX/etc/hadoop/core-site.xml
ADD hdfs-site.xml $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
ADD mapred-site.xml $HADOOP_PREFIX/etc/hadoop/mapred-site.xml
ADD yarn-site.xml $HADOOP_PREFIX/etc/hadoop/yarn-site.xml
ADD slaves $HADOOP_PREFIX/etc/hadoop/slaves
ADD .bash_aliases /root/.bash_aliases

# add bootstrap.sh
RUN apt-get install sshpass
ADD bootstrap.sh /etc/bootstrap.sh

# generate ssh keys
RUN cd /root && ssh-keygen -t dsa -P '' -f "/root/.ssh/id_dsa" \
&& cat /root/.ssh/id_dsa.pub >> /root/.ssh/authorized_keys && chmod 644 /root/.ssh/authorized_keys

# configure ssh
ADD ssh-config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config

# configure .bashrc
RUN echo 'cd /usr/local/hadoop' >> /root/.bashrc
RUN echo 'export PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin' >> /root/.bashrc
RUN echo '. ~/.bash_aliases' >> /root/.bashrc

EXPOSE 22
CMD ["/etc/bootstrap.sh", "-D"]
