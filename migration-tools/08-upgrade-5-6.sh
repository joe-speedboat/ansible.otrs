#!/bin/bash
# upgrade-5-6.sh

screen -S upgrade

usermod -s /bin/bash otrs

otrs_rpm_url="https://ftp.otrs.org/pub/otrs/RPMS/rhel/7/otrs-6.0.4-03.noarch.rpm"
systemctl stop crond postfix httpd
systemctl disable crond postfix httpd
su - otrs -c 'cd /opt/otrs ; bin/Cron.sh stop'
su - otrs -c 'cd /opt/otrs ; bin/otrs.Daemon.pl stop'

mkdir -p /backup/5/cfg
cd /opt/otrs
cp -a Kernel/Config.pm Kernel/Config/Files/ZZZAuto.pm /backup/5/cfg/
mysqldump otrs | gzip > /backup/5/otrs.mysql.gz
tar cfz /backup/5/opt_otrs.tar.gz /opt/otrs
ls -lah /backup/5/ /backup/5/cfg/

yum -y install "$otrs_rpm_url"


su - otrs -c 'cd /opt/otrs ; scripts/DBUpdate-to-6.pl'
su - otrs -c 'cd /opt/otrs ; bin/otrs.Console.pl Admin::Package::UpgradeAll'

systemctl start crond postfix httpd
systemctl enable crond postfix httpd


su - otrs -c 'cd /opt/otrs ; /opt/otrs/bin/otrs.Daemon.pl start'
su - otrs -c 'cd /opt/otrs ; /opt/otrs/bin/Cron.sh start'


usermod -s /bin/false otrs
