### 镜像制作与挂载

- `/dev/cdrom` 为设备
- `/root/busybox` 为文件夹

  
    # 设备内容 => iso
    方法1：dd if=/dev/cdrom of=/root/busybox.iso
    方法2：cat /dev/cdrom >;/root/busybox.iso
    
    # 文件系统 => iso
    方法3：mkisofs -r -o busybox.iso /root/busybox
    方法4：cp -r /root/busybox busybox.iso
    
挂载使用
---
    
    # 挂载
    mount -o loop busybox.iso /mnt
    # 卸载
    umount /mnt