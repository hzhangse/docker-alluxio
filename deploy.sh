#!/bin/bash
sudo su root


rm -rf /etc/glusterfs{1,2,3,4,5,6} /var/lib/glusterd{1,2,3,4,5,6} /var/log/glusterfs{1,2,3,4,5,6}

mkdir -p /etc/glusterfs{1,2,3,4,5,6} /var/lib/glusterd{1,2,3,4,5,6} /var/log/glusterfs{1,2,3,4,5,6}

for i in `seq 1 6`; do
        mkdir -p $etc$i $var$i $log$i
        docker run -d --privileged=true --name gluster$i --hostname=gluster$i \
                -v /etc/glusterfs$i:/etc/glusterfs:z \
                -v /var/lib/glusterd$i:/var/lib/glusterd:z \
                -v /var/log/glusterfs$i:/var/log/glusterfs:z \
                -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
                -v /dev:/dev \
                -v /home/ryan/gluster/172.19.0.10$i:/mnt \
                 --net shadownet --ip 172.19.0.10$i \
                gluster/gluster-centos
done

docker exec -ti gluster1 /bin/bash

gluster peer probe 172.19.0.102
gluster peer probe 172.19.0.103

gluster peer probe 172.19.0.104
gluster peer probe 172.19.0.105
gluster peer probe 172.19.0.106
-----------------------------------------------------------------------------
gluster volume stop es0
gluster volume stop es1
gluster volume stop es2

gluster volume delete es0
gluster volume delete es1
gluster volume delete es2

gluster volume create es0 strip 2 replica 3 172.19.0.10{1,2,3,4,5,6}:/mnt/es0 
gluster volume create es1 strip 2 replica 3 172.19.0.10{1,2,3,4,5,6}:/mnt/es1 
gluster volume create es2 strip 2 replica 3 172.19.0.10{1,2,3,4,5,6}:/mnt/es2 
gluster volume create es3 strip 2 replica 3 172.19.0.10{1,2,3,4,5,6}:/mnt/es3


gluster volume start es0
gluster volume start es1
gluster volume start es2
gluster volume start es3

umount /mnt/es0
umount /mnt/es1
umount /mnt/es2
umount /mnt/es3
rm -rf /mnt/es{0,1,2,3}



mkdir -p /mnt/es{0,1,2,3}

mount -t glusterfs 172.19.0.101,172.19.0.102,172.19.0.103,172.19.0.104,172.19.0.105,172.19.0.106:/es0 /mnt/es0/
mount -t glusterfs 172.19.0.101,172.19.0.102,172.19.0.103,172.19.0.104,172.19.0.105,172.19.0.106:/es1 /mnt/es1/
mount -t glusterfs 172.19.0.101,172.19.0.102,172.19.0.103,172.19.0.104,172.19.0.105,172.19.0.106:/es2 /mnt/es2/
mount -t glusterfs 172.19.0.101,172.19.0.102,172.19.0.103,172.19.0.104,172.19.0.105,172.19.0.106:/es3 /mnt/es3/
----------------------------------------------------------------------------------
rm -rf /etc/glusterfs{1,2,3} /var/lib/glusterd{1,2,3} /var/log/glusterfs{1,2,3}

mkdir -p /etc/glusterfs{1,2,3} /var/lib/glusterd{1,2,3} /var/log/glusterfs{1,2,3}

for i in `seq 1 3`; do
        mkdir -p $etc$i $var$i $log$i
        docker run -d --privileged=true --name gluster$i --hostname=gluster$i \
                -v /etc/glusterfs$i:/etc/glusterfs:z \
                -v /var/lib/glusterd$i:/var/lib/glusterd:z \
                -v /var/log/glusterfs$i:/var/log/glusterfs:z \
                -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
                -v /dev:/dev \
                -v /home/ryan/gluster/172.19.0.10$i:/mnt \
                 --net shadownet --ip 172.19.0.10$i \
                gluster/gluster-centos
done

docker exec -ti gluster1 /bin/bash

gluster peer probe 172.19.0.102
gluster peer probe 172.19.0.103

gluster volume stop es0
gluster volume stop es1
gluster volume stop es2
gluster volume stop es3

gluster volume delete es0
gluster volume delete es1
gluster volume delete es2
gluster volume delete es3

gluster  volume create es0  replica 3 172.19.0.10{1,2,3}:/mnt/es0 
gluster  volume create es1  replica 3 172.19.0.10{1,2,3}:/mnt/es1 
gluster  volume create es2  replica 3 172.19.0.10{1,2,3}:/mnt/es2 
gluster  volume create es3  replica 3 172.19.0.10{1,2,3}:/mnt/es3

gluster volume start es2
gluster volume start es0
gluster volume start es1
gluster volume start es3



umount /mnt/es0
umount /mnt/es1
umount /mnt/es2
umount /mnt/es3
rm -rf /mnt/es{0,1,2,3}



mkdir -p /mnt/es{0,1,2,3}
mount -t glusterfs 172.19.0.101,172.19.0.102,172.19.0.103:/es0 /mnt/es0/
mount -t glusterfs 172.19.0.101,172.19.0.102,172.19.0.103:/es1 /mnt/es1/
mount -t glusterfs 172.19.0.101,172.19.0.102,172.19.0.103:/es2 /mnt/es2/
mount -t glusterfs 172.19.0.101,172.19.0.102,172.19.0.103:/es3 /mnt/es3/
--------------------------------------------------------------------------------------







gluster  volume create es0 disperse 3 redundancy 1 172.19.0.10{1,2,3}:/mnt/es0 force
gluster  volume create es1 disperse 3 redundancy 1 172.19.0.10{1,2,3}:/mnt/es1 force
gluster  volume create es2 disperse 3 redundancy 1 172.19.0.10{1,2,3}:/mnt/es2 force



mkdir -p /mnt/glusterfs
mount -t glusterfs 172.19.0.101,172.19.0.102,172.19.0.103:/es0 /mnt/glusterfs/
echo '172.19.0.101:/v1 /mnt/glusterfs glusterfs defaults 0 1' >> /etc/fstab #设置自动挂载



sudo docker run -it -p 3000:3000  --name gluster-console -d --net shadownet  like/gluster-web-interface


sudo docker exec -ti gluster-console /bin/bash





docker volume create --driver sapk/plugin-gluster --opt voluri="172.19.0.101,172.19.0.102,172.19.0.103:/es0" --name es-master
docker volume create --driver sapk/plugin-gluster --opt voluri="172.19.0.101,172.19.0.102,172.19.0.103:/es1" --name es-node1
docker volume create --driver sapk/plugin-gluster --opt voluri="172.19.0.101,172.19.0.102,172.19.0.103:/es2" --name es-node2
docker run -v estest:/mnt --rm -ti ubuntu




