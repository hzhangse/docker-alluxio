export INSTANCE_PUBLIC_IP=172.19.0.111
#sudo mount -t ramfs none /mnt/ramdisk/
#suod mount -t ramfs none  /mnt/ramdisk/ -o maxsize=500000
#-e ALLUXIO_USER_FILE_WRITETYPE_DEFAULT=CACHE_THROUGH 
# Launch an Alluxio worker container and save the container ID for later

sudo docker run -d --cap-add SYS_ADMIN --device /dev/fuse --name alluxio-fuse-master --privileged \
               --net shadownet --ip ${INSTANCE_PUBLIC_IP} -e ENABLE_FUSE=false \
                -e ALLUXIO_MASTER_HOSTNAME=${INSTANCE_PUBLIC_IP} \
                -e ALLUXIO_UNDERFS_ADDRESS=/underStorage \
                -e ALLUXIO_USER_FILE_READTYPE_DEFAULT=CACHE_PROMOTE \
                -e ALLUXIO_USER_FILE_WRITETYPE_DEFAULT=CACHE_THROUGH \
                -v `pwd`/log-master:/opt/alluxio/logs/ \
                --volume /sys/fs/cgroup:/sys/fs/cgroup:ro \
                -v /mnt/alluxio:/underStorage \
                 registry.cn-hangzhou.aliyuncs.com/rainbow954/alluxio-fuse-1.7:1.7.1 master 

sudo docker run -d --net shadownet --ip 172.19.0.112 --name alluxio-work0 -h alluxio-work0\
             -v /mnt/ramdisk:/opt/ramdisk \
             -v /mnt/alluxio:/underStorage \
             -e ALLUXIO_MASTER_HOSTNAME=${INSTANCE_PUBLIC_IP} \
             -e ALLUXIO_RAM_FOLDER=/opt/ramdisk \
             -e ALLUXIO_WORKER_MEMORY_SIZE=1GB -e ALLUXIO_UNDERFS_ADDRESS=/underStorage \
              registry.cn-hangzhou.aliyuncs.com/rainbow954/alluxio-1.7:1.7.1 worker

sudo docker run -d --net shadownet --ip 172.19.0.113 --name alluxio-work1 -h alluxio-work1\
             -v /mnt/ramdisk:/opt/ramdisk \
             -v /mnt/alluxio:/underStorage \
             -e ALLUXIO_MASTER_HOSTNAME=${INSTANCE_PUBLIC_IP} \
             -e ALLUXIO_RAM_FOLDER=/opt/ramdisk \
             -e ALLUXIO_WORKER_MEMORY_SIZE=1GB -e ALLUXIO_UNDERFS_ADDRESS=/underStorage \
               registry.cn-hangzhou.aliyuncs.com/rainbow954/alluxio-1.7:1.7.1 worker
