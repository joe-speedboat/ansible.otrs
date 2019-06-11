# 08-upgrade-patch-6.sh

# https://doc.otrs.com/doc/manual/admin/6.0/en/html/updating.html

[root@otrs1 ~]# rpm -qa | grep otrs
   otrs-6.0.5-01.noarch

screen -S upgrade

usermod -s /bin/bash otrs

otrs_rpm_url="https://ftp.otrs.org/pub/otrs/RPMS/rhel/7/otrs-6.0.4-03.noarch.rpm"
otrs_rpm_url="https://ftp.otrs.org/pub/otrs/RPMS/rhel/7/otrs-6.0.5-01.noarch.rpm"
otrs_rpm_url="https://ftp.otrs.org/pub/otrs/RPMS/rhel/7/otrs-6.0.6-01.noarch.rpm"
otrs_rpm_url="https://ftp.otrs.org/pub/otrs/RPMS/rhel/7/otrs-6.0.7-01.noarch.rpm"
otrs_rpm_url="https://ftp.otrs.org/pub/otrs/RPMS/rhel/7/otrs-6.0.14-01.noarch.rpm"
otrs_rpm_url="https://ftp.otrs.org/pub/otrs/RPMS/rhel/7/otrs-6.0.19-02.noarch.rpm"
# https://community.otrs.com/release-notes-otrs-6-patch-level-19/

systemctl stop crond postfix httpd
systemctl disable crond postfix httpd
su - otrs -c 'cd /opt/otrs ; bin/Cron.sh stop'
su - otrs -c 'cd /opt/otrs ; bin/otrs.Daemon.pl stop'

yum -y install "$otrs_rpm_url"

su - otrs -c 'cd /opt/otrs ; scripts/DBUpdate-to-6.pl'
su - otrs -c 'cd /opt/otrs ; bin/otrs.Console.pl Admin::Package::UpgradeAll'

systemctl start crond postfix httpd
systemctl enable crond postfix httpd


su - otrs -c 'cd /opt/otrs ; /opt/otrs/bin/otrs.Daemon.pl start'
su - otrs -c 'cd /opt/otrs ; /opt/otrs/bin/Cron.sh start'


usermod -s /bin/false otrs
