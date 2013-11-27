#!/bin/bash
#
echo "this will take about 12 minutes to install.  Starting in 3 seconds..."
sleep 3
#
apt-get update
apt-get -y install build-essentials
apt-get -y install sqlite3
apt-get -y install libsqlite3-dev
apt-get -y install asterisk
apt-get -y install mpg123
#load languages
apt-get -y install ruby
apt-get -y install rubygems
gem install ruby-agi
apt-get -y install php
apt-get -y install nodejs
apt-get -y install nodejs-dev
apt-get -y install xml2
apt-get -y install libxml2-dev
apt-get -y install curl
apt-get -y install libssl0.9.8
apt-get -y install libssl-dev
apt-get -y install git
#prep asterisk for multiple users
touch /etc/asterisk/userconf_extensions.conf
echo "#include /etc/asterisk/userconf_extensions.conf" >> /etc/asterisk/extensions.conf
touch /etc/asterisk/userconf_sip.conf
echo "#include /etc/asterisk/userconf_sip.conf" >> /etc/asterisk/sip.conf
touch /etc/asterisk/userconf_iax.conf
echo "#include /etc/asterisk/userconf_iax.conf" >> /etc/asterisk/iax.conf
touch /etc/asterisk/userconf_voicemail.conf
echo "#include /etc/asterisk/userconf_voicemail.conf" >> /etc/asterisk/voicemail.conf
touch /etc/asterisk/userconf_musiconhold.conf
echo "#include /etc/asterisk/userconf_musiconhold.conf" >> /etc/asterisk/musiconhold.conf
asterisk -rx "module reload"
chmod 777 /var/spool/asterisk/outgoing
#patch ruby-agi
cd /tmp
wget http://www.itp-redial.com/class/wp-content/uploads/2012/02/ruby-agi-2.0.0.zip
apt-get -y install unzip 
unzip ruby-agi-2.0.0.zip 
cd ruby-agi-2.0.0/lib/ruby-agi/rs
mv -f receive_char.rb /var/lib/gems/1.8/gems/ruby-agi-2.0.0/lib/ruby-agi/rs/
cd ..
mv -f return_status.rb /var/lib/gems/1.8/gems/ruby-agi-2.0.0/lib/ruby-agi/
mv -f asterisk_variable.rb /var/lib/gems/1.8/gems/ruby-agi-2.0.0/lib/ruby-agi/
rm -rf ruby-agi-2.0.0.zip
rm -rf ruby-agi-2.0.0
cd ~
#copy public IP address to file /etc/publicIP
wget -F http://www.whatismyip.org/ -O /etc/publicIP
export PUBLIC_IP=`cat /etc/publicIP`
#add cloud9
mkdir /root/node_workspace
curl http://npmjs.org/install.sh | sh
git clone git://github.com/ajaxorg/cloud9.git
cd cloud9
git submodule update --init --recursive
#add basic auth module
git clone git://github.com/semu/connect-basic-auth.git support/connect-basic-auth
#add modified source files for node js
wget http://www.itp-redial.com/class/wp-content/uploads/2012/02/config.js -O config.js
#add public IP address to config file
sed -i -e "s/PUBLICIP/$PUBLIC_IP/" config.js
wget http://www.itp-redial.com/class/wp-content/uploads/2012/02/cloud9.js -O bin/cloud9.js
wget http://www.itp-redial.com/class/wp-content/uploads/2012/02/index.js -O server/cloud9/index.js
wget http://www.itp-redial.com/class/wp-content/uploads/2012/02/paths.js -O support/paths.js
#node bin/cloud9.js -c config.js

#install http server
apt-get -y install apache2
wget http://www.itp-redial.com/class/wp-content/uploads/2012/03/httpd.conf_.txt -O /etc/apache2/httpd.conf
#cp /usr/share/doc/apache2.2-common/examples/apache2/extra/httpd-userdir.conf /etc/apache2/httpd.conf
a2enmod userdir
service apache2 restart

#install sinatra
gem install sinatra
gem install haml

#install passenger so sinatra can be run in apache
#apt-get -y install libcurl4-openssl-dev
#apt-get -y install apache2-prefork-dev
#apt-get -y install libapr1-dev
#apt-get -y install libaprutil1-dev
apt-get -y install libapache2-mod-passenger
#gem install passenger
#passenger-install-apache2-module -a
sed -i 's/ 00:00:00.000000000Z//' /var/lib/gems/1.8/specifications/*
#echo "LoadModule passenger_module /var/lib/gems/1.8/gems/passenger-3.0.11/ext/apache2/mod_passenger.so" >> /etc/apache2/httpd.conf
#echo "PassengerRoot /var/lib/gems/1.8/gems/passenger-3.0.11" >> /etc/apache2/httpd.conf
#echo "PassengerRuby /usr/bin/ruby1.8" >> /etc/apache2/httpd.conf
service apache2 restart
#download userful scripts
ln -s /root /home/root
cd ~
mkdir -p ~/scripts
wget http://www.itp-redial.com/class/wp-content/uploads/2012/03/new_sinatra_app.txt -O scripts/new_sinatra_app.rb
wget http://www.itp-redial.com/class/wp-content/uploads/2012/03/make-user.txt -O scripts/make-user.sh
wget http://www.itp-redial.com/class/wp-content/uploads/2012/03/make-ast-user.txt -O scripts/make-ast-user.sh
chmod 755 scripts/make-ast-user.sh
chmod 755 scripts/make-user.sh
chmod 755 scripts/new_sinatra_app.rb
#install tinyphone
cd ~/node_workspace
git clone git://github.com/itp-redial/tinyphone
#add socket.io and Forever
export NODE_PATH=/usr/lib/node_modules/
echo "export NODE_PATH=$NODE_PATH" >> ~/.bashrc
npm install socket.io -g
npm install forever -g
#compile cloud9
echo "******* I'm about to compile and run cloud9"
echo "******* when the compile is complete, please ctrl-c cloud 9."
echo "******* edit config.js and change the username and password."
echo "******* From now on, run cloud9 by entering"
echo "******* node bin/cloud9.js -c config.js"
sleep 4
cd ~/cloud9
bin/cloud9.sh