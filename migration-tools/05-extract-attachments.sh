



In Sysconfig, Search ArticleStorage
   Change to: ArticleStorageFS

screen -S upgrade

- stop otrs
  systemctl stop crond httpd
  su - otrs -c 'bin/Cron.sh stop'
  su - otrs -c 'bin/otrs.Scheduler.pl -a stop'


su - otrs
  bin/otrs.ArticleStorageSwitch.pl -s ArticleStorageDB -d ArticleStorageFS
  # ca 6h

- shrink DB
  mysqldump otrs > /root/otrs.mysql
  sh -lah /root/otrs.mysql # 458 MB
  du -hcs /var/lib/mysql #14GB
  mysql -e  'drop database otrs;'
  systemctl stop mariadb
  rm -f /var/lib/mysql/ib*
  systemctl start mariadb
  du -hcs /var/lib/mysql
  mysql -e 'CREATE DATABASE otrs CHARACTER SET utf8 COLLATE utf8_general_ci;'
  mysql -e 'show databases;'
  du -hcs /var/lib/mysql #500MB
  mysql otrs < /root/otrs.mysql
  du -hcs /var/lib/mysql #1500 MB

- start otrs and test
  systemctl start crond httpd
  su - otrs -c 'bin/Cron.sh start'
  su - otrs -c 'bin/otrs.Scheduler.pl -a start'

- shutdown, snapshot

