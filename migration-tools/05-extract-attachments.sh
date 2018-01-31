
In Sysconfig, Search ArticleStorage
   Change to: ArticleStorageFS

- stop otrs
  systemctl stop crond httpd
  su - otrs -c 'bin/Cron.sh stop'
  su - otrs -c 'bin/otrs.Scheduler.pl -a stop'


su - otrs
  bin/otrs.ArticleStorageSwitch.pl -s ArticleStorageDB -d ArticleStorageFS
  # ca 6h (mssql)

- shrink DB
  


