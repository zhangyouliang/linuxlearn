### docker 容器,镜像打包以及恢复

容器 => 镜像
---

    # 将正在运行的容器 => 镜像
    docker commit 812a997f614a busybox:update
    # 比较容器的变化
    docker diff 1610771c6631
    
    
容器 <=> 文件 
---

    # container => file
    docker export cbe3cb7799ed > busybox.tar
    # file => container (busybox:latest)
    docker import - busybox < busybox.tar 

镜像 <=> 文件
----
    #  image(busybox:latest) => file
    docker save -o busybox.tar busybox:latest
    # busybox
    docker load < busybox.tar 
    
busybox镜像解压到本地目录 
---

    (docker export $(docker create busybox) | tar -C rootfs -xvf -)
    
    # 快速打包一个 busybox 镜像
    mkdir busybox
    (docker export $(docker create busybox) | tar -C busybox -xvf -)
    cd busybox
    tar -cvpf ../busybox.tar --exclude=proc --exclude=sys --exclude=dev --exclude=run --exclude=boot .
    # 镜像查看
    tar -tf ../busybox.tar
    