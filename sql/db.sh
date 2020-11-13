#!/bin/bash

if [ $1 == "-b" ]; then
    echo "backup databases……"
    mysqldump -unova -prh123456 nova >nova.sql
    mysqldump -unova -prh123456 nova_api >nova_api.sql
    mysqldump -uglance -prh123456 glance >glance.sql
    mysqldump -ucinder -prh123456 cinder >cinder.sql
    mysqldump -uneutron -prh123456 neutron >neutron.sql
    mysqldump -ukeystone -prh123456 keystone >keystone.sql
elif [ $1 == "-r" ]; then
    echo "recover databases……"
    mysql -unova -prh123456 nova <nova.sql
    mysql -unova -prh123456 nova_api <nova_api.sql
    mysql -uglance -prh123456 glance <glance.sql
    mysql -uneutron -prh123456 neutron <neutron.sql
    mysql -ucinder -prh123456 cinder <cinder.sql
    # mysql -ukeystone -prh123456 keystone< keystone.sql
else
    echo "Usage: bash db.sh -b|-r"
fi
