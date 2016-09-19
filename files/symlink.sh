cd /opt/

date_now=`date "+%Y%m%d-%H%M%S"`

function bak-and-ln() {
    sudo mv /etc/$1{,.bak}
    sudo ln -s /opt/isucon6q/etc/$1 /etc/$1
}

# config
git clone git@github.com:nonylene/isucon6q.git
sudo cp -r /etc/nginx{,.bak.$date_now}
sudo cp -r /etc/mysql{,.bak.$date_now}
sudo cp -r /etc/security{,.bak.$date_now}
sudo cp -r /etc/systemd{,.bak.$date_now}

bak-and-ln nginx/nginx.conf

bak-and-ln mysql/my.cnf
bak-and-ln mysql/mysql.conf.d/mysqld.cnf

bak-and-ln security/limits.conf

# bak-and-ln systemd/system/isutar.perl.service
# bak-and-ln systemd/system/isutar.ruby.service
# bak-and-ln systemd/system/isutar.go.service
# bak-and-ln systemd/system/isutar.js.service
# bak-and-ln systemd/system/isutar.python.service
# bak-and-ln systemd/system/isutar.php.service
# bak-and-ln systemd/system/isutar.scala.service
#
# bak-and-ln systemd/system/isutar.perl.service
# bak-and-ln systemd/system/isutar.ruby.service
# bak-and-ln systemd/system/isutar.go.service
# bak-and-ln systemd/system/isutar.js.service
# bak-and-ln systemd/system/isutar.python.service
# bak-and-ln systemd/system/isutar.php.service
# bak-and-ln systemd/system/isutar.scala.service
#
# bak-and-ln systemd/system/isupam.service

sudo service nginx restart
sudo service mysql restart

# webapp
# sudo systemctl stop isutar.perl.service
# sudo systemctl stop isuda.perl.service

sudo mv /home/isucon/webapp{,bak}
sudo ln -s /opt/isucon6q/webapp /home/isucon/webapp
cd /home/isucon/webapp/ruby
/home/isucon/.local/ruby/bin/bundle install

# sudo systemctl start isutar.ruby.service
# sudo systemctl start isuda.ruby.service
