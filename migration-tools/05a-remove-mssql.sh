
- remove packages
  yum -y remove mssql-server mssql-tools msodbcsql
  yum -y remove unixODBC-devel unixODBC libtool-ltdl gdb libsss_nss_idmap
  rm -f /etc/yum.repos.d/ms*
  rm -rf /opt/mssql* /opt/backup/ /var/opt/mssql /usr/share/doc/mssql-server

- shutdown, snapshot


