#!/bin/bash

# upgrade-3.3.9-4.sh
otrs_rpm_url="https://ftp.otrs.org/pub/otrs/RPMS/rhel/7/otrs-4.0.28-01.noarch.rpm"

screen -S upgrade



systemctl stop crond postfix httpd
systemctl disable crond postfix httpd


cd /opt/otrs
tar vxfz /root/Kernel_v3.tar.gz
chown otrs.apache Kernel/ Kernel/Config.pm Kernel/Config/ Kernel/Config/Files/ Kernel/Config/Files/ZZZAAuto.pm Kernel/Config/Files/ZZZACL.pm Kernel/Config/Files/ZZZAuto.pm
chmod 775 Kernel/ Kernel/Config/ Kernel/Config/Files/
chmod 664 Kernel/Config.pm Kernel/Config/Files/ZZZAAuto.pm Kernel/Config/Files/ZZZACL.pm Kernel/Config/Files/ZZZAuto.pm


systemctl start crond postfix httpd
# test otrs and Dynamic Fields
#*********************************************************
#	 CAUTION: UNINSTALL FAQ + DB-Clone PACKAGE !!!
#                 Re Install Support Module
#*********************************************************
systemctl stop crond postfix httpd


usermod -s /bin/bash otrs

systemctl stop crond postfix httpd
systemctl disable crond postfix httpd
su - otrs -c 'bin/Cron.sh stop'
su - otrs -c 'bin/otrs.Scheduler.pl -a stop'

yum -y install "$otrs_rpm_url"

su - otrs -c "bin/otrs.CheckDB.pl"
cd /opt/otrs
cat scripts/DBUpdate-to-4.mysql.sql | mysql -f -u root otrs

su - otrs -c 'cd /opt/otrs ; scripts/DBUpdate-to-4.pl'

systemctl start crond httpd


read -p "Check the installed packages in OTRS:
         Step 9: Check installed packages
	 Step 11: Check GenericAgent jobs

	 CAUTION: UNINSTALL FAQ + DB-Clone PACKAGE !!!

	 http://doc.otrs.com/doc/manual/admin/4.0/en/html/upgrading.html
         
         Hit ENTER when done
         "


su - otrs -c 'cd /opt/otrs/var/cron ; for foo in *.dist; do cp $foo `basename $foo .dist`; done ; ls -l'
read -p "Hit ENTER when OK"

su - otrs -c 'cd /opt/otrs ; /opt/otrs/bin/Cron.sh start'
su - otrs -c 'cd /opt/otrs ; bin/otrs.RebuildTicketIndex.pl'

usermod -s /bin/false otrs
