#!/bin/bash

#李晓流编写
#删除文件
rm /root/macvmsc.sh
#大量文本不转义写入文件
cat > /root/macvmsc.sh << 'EOF'
#!/bin/bash
logfile="/root/hooks.log"
echo "Hook VM power on "$(date "+%Y-%m-%d %H:%M:%S") >> $logfile
#睡眠50秒给点缓冲时间避免pve虚拟机有问题没时间处理就自动关机了
sleep 50
while true
do
#睡眠5秒
sleep 5
process=`ps aux | grep /bin/kvm | grep -v grep`;
if [ "$process" == "" ];then
echo "all kvm process stoped "$(date "+%Y-%m-%d %H:%M:%S") >> $logfile
echo not running
#执行关机操作
shutdown -h now
else
sleep 5
#睡眠5秒
#echo "kvm process runing "$(date "+%Y-%m-%d %H:%M:%S") >> $logfile
fi
done
EOF
#加执行权限
chmod +x /root/macvmsc.sh
#新增目录
mkdir /var/lib/vz/snippets
#删除文件
rm /var/lib/vz/snippets/hooks.pl
#大量文本不转义写入文件
cat > /var/lib/vz/snippets/hooks.pl << 'EOF'
#!/usr/bin/perl
use strict;
use warnings;
use POSIX;
print "GUEST HOOK: " . join(' ', @ARGV). "\n";
my $vmid = shift;
my $phase = shift;
if ($phase eq 'pre-start') {
system("setsid /root/macvmsc.sh >/dev/null 2>&1 &");
}
exit(0);
EOF
#加执行权限
chmod +x /var/lib/vz/snippets/hooks.pl

# 配置哪一个虚拟机使用钩子脚本
read -p "请输入哪一个虚拟机编号使用这个钩子脚本，输入后才能进入下一步骤比如111： " numvfs
qm set $numvfs --hookscript local:snippets/hooks.pl

echo "请开机黑苹果，试试黑苹果关机后，pve物理机是否一起关机"
echo "脚本结束" 
