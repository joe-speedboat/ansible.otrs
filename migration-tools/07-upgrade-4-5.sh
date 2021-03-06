#!/bin/bash
# upgrade-4-5.sh


screen -S upgrade

usermod -s /bin/bash otrs

otrs_rpm_url="https://ftp.otrs.org/pub/otrs/RPMS/rhel/7/otrs-5.0.26-01.noarch.rpm"
systemctl stop crond postfix httpd
systemctl disable crond postfix httpd
su - otrs -c 'cd /opt/otrs ; bin/Cron.sh stop'
su - otrs -c 'cd /opt/otrs ; bin/otrs.Scheduler.pl -a stop'

yum -y install "$otrs_rpm_url"

/opt/otrs/bin/otrs.CheckModules.pl

cd /opt/otrs
cat scripts/DBUpdate-to-5.mysql.sql | mysql -f -u root otrs

su - otrs -c 'cd /opt/otrs ; bin/otrs.Console.pl Maint::Database::MySQL::InnoDBMigration'
su - otrs -c 'cd /opt/otrs ; bin/otrs.Console.pl Maint::Database::Check'
su - otrs -c 'cd /opt/otrs ; scripts/DBUpdate-to-5.pl'
su - otrs -c 'cd /opt/otrs ; bin/otrs.Console.pl Maint::Database::Check'
su - otrs -c 'cd /opt/otrs ; bin/otrs.Console.pl Maint::Config::Rebuild'
su - otrs -c 'cd /opt/otrs ; bin/otrs.Console.pl Maint::Cache::Delete'


systemctl start crond  httpd
systemctl enable crond httpd


read -p "Check the installed packages in OTRS:
         Step 9: Check installed packages
	 ---> no packages are installed
	 
	 Hit ENTER when done
	 "

su - otrs -c 'cd /opt/otrs ; /opt/otrs/bin/otrs.Daemon.pl start'
su - otrs -c 'cd /opt/otrs/var/cron ; for foo in *.dist; do cp $foo `basename $foo .dist`; done ; ls -l'

read -p "Step 14: Review your ticket notifications
	 

	Hit ENTER when OK"


su - otrs -c 'cd /opt/otrs ; /opt/otrs/bin/Cron.sh start'


usermod -s /bin/false otrs
