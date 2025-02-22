# pve-mac-hook

有这个想法的原因是，pve下独显直通直通黑苹果后用着很舒服，想着能像物理机一样同步开机和同步关机黑苹果虚拟机。然后试了一天，终于实现了，本来钩子程序是没法实现这个功能的（虚拟机关机钩子是无法检测的），我想了个办法，在黑苹果开机的时候挂钩子，钩子里面开进程检测kvm运行状态，如果一个kvm进程也没有，那就立即关机pve。程序全自动，弄好了无需访问pve网页控制黑苹果虚拟机了。

The idea originated from the fact that after setting up GPU passthrough for a Hackintosh virtual machine in Proxmox VE (PVE), it worked smoothly. I wanted to achieve synchronized startup and shutdown of the Hackintosh VM just like a physical machine. After a day of experimentation, I finally succeeded. Originally, hook scripts couldn't accomplish this functionality (as VM shutdown events couldn't be detected through hooks). My solution was to implement a hook when the Hackintosh boots up. This hook launches a process that continuously monitors KVM's operational status. When no KVM processes are detected (indicating all VMs are shut down), it automatically triggers a shutdown of the PVE host. The entire process is fully automated, eliminating the need to manually control the Hackintosh VM through the PVE web interface.

直接复制pve-mac-hook.sh中的全部脚本张贴进终端一键运行就是！！！

Just copy the entire script from pve-mac-hook.sh and paste it into the terminal to run it with one command!!!

也有一些小缺点（我觉得都不是什么缺点）：

There are a few minor drawbacks (which I don't consider significant):

1、虚拟机最好只设置一个黑苹果自动开机，黑苹果关机的时候pve物理机就自动关机了。如果你运行了开机了多个虚拟机，除非这些虚拟机都关机了，物理机才能立马关机。因为原理是我是检测kvm进程都没了才关机pve。比如你pkill kvm杀掉所有kvm进程也会关机。

1.Single VM Auto-Boot Limitation.It's recommended to configure only one Hackintosh VM for automatic startup. When this Hackintosh shuts down, the Proxmox VE (PVE) host will automatically power off. However, if multiple VMs are running, the PVE host will only shut down immediately after all VMs are powered off. This occurs because the underlying mechanism checks if all KVM processes have terminated before shutting down the PVE host. For example, manually terminating all KVM processes (e.g., using pkill kvm) would also trigger a host shutdown.

2、黑苹果不能设置睡眠（一是睡眠了唤醒有问题，二是睡眠了你得另外开个机器pve后台恢复黑苹果运行），干脆就丢掉睡眠吧。重启黑苹果不会导致pve物理机自动关机。 

2.Hackintosh Sleep Mode Incompatibility.Sleep mode should be disabled for Hackintosh VMs due to:Wake-from-sleep instability issues.The impractical requirement of needing another device to manually resume the VM from sleep via the PVE backend.Notably, restarting the Hackintosh VM won't trigger an automatic shutdown of the PVE host.

作者：李晓流 

Author:lixiaoliu

https://www.bilibili.com/read/cv32880920/?opus_fallback=1 出处from：bilibili
