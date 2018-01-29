#!/bin/bash
# upgrade-3.3.9-4.sh
otrs_rpm_url="https://ftp.otrs.org/pub/otrs/RPMS/rhel/7/otrs-4.0.28-01.noarch.rpm"

usermod -s /bin/bash otrs

systemctl stop crond postfix httpd
systemctl disable crond postfix httpd
su - otrs -c 'bin/Cron.sh stop'
su - otrs -c 'bin/otrs.Scheduler.pl -a stop'

yum -y install "$otrs_rpm_url"

su - otrs -c "bin/otrs.CheckDB.pl"
cat scripts/DBUpdate-to-4.mysql.sql | mysql -f -u root otrs

su - otrs -c 'cd /opt/otrs ; scripts/DBUpdate-to-4.pl'
su - otrs -c 'cd /opt/otrs ; bin/otrs.RebuildConfig.pl'
su - otrs -c 'cd /opt/otrs ; bin/otrs.DeleteCache.pl'

systemctl start crond postfix httpd
systemctl enable crond postfix httpd

read -p "Check the installed packages in OTRS:
         Step 9: Check installed packages
	 Step 11: Check GenericAgent jobs
         
         Hit ENTER when done
         "


su - otrs -c 'cd /opt/otrs/var/cron ; for foo in *.dist; do cp $foo `basename $foo .dist`; done ; ls -l'
read -p "Hit ENTER when OK"

su - otrs -c 'cd /opt/otrs ; /opt/otrs/bin/Cron.sh start'
su - otrs -c 'cd /opt/otrs ; bin/otrs.RebuildTicketIndex.pl'

usermod -s /bin/false otrs
