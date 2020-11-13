#!/bin/bash
# 备份替换所需的代码以及配置文件

dt=$(date '+%Y%m%d')

if [ $1 == "control" ]; then
    echo "starting..." 
    if [ $2 == "backup" ]; then
        mv /usr/lib/python2.7/site-packages/nova /usr/lib/python2.7/site-packages/nova_bak_$dt &&
        mv /usr/lib/python2.7/site-packages/novaclient /usr/lib/python2.7/site-packages/novaclient_bak_$dt &&
        mv /usr/lib/python2.7/site-packages/glance /usr/lib/python2.7/site-packages/glance_bak_$dt &&
        mv /usr/lib/python2.7/site-packages/glance_store /usr/lib/python2.7/site-packages/glance_store_bak_$dt &&
        mv /usr/lib/python2.7/site-packages/glanceclient /usr/lib/python2.7/site-packages/glanceclient_bak_$dt &&

        cp -a /etc/nova/nova.conf /etc/nova/nova.conf_bak_$dt && 
        cp -a /etc/neutron/neutron.conf /etc/neutron/neutron.conf_bak_$dt &&         
        cp -a /etc/glance/glance-api.conf /etc/glance/glance-api.conf_bak_$dt && 
        cp -a /etc/cinder/cinder.conf /etc/cinder/cinder.conf_bak_$dt && 
        echo "backup code and configuration finish..." 
    elif [ $2 == "replace" ]; then
        cd /usr/lib/python2.7/site-packages/ &&
        cp -a nova /usr/lib/python2.7/site-packages/ &&
        cp -a novaclient /usr/lib/python2.7/site-packages/ &&
        cp -a glance /usr/lib/python2.7/site-packages/ &&
        cp -a glance_store /usr/lib/python2.7/site-packages/ &&
        cp -a glanceclient /usr/lib/python2.7/site-packages/ &&
        find nova -type d |xargs chmod 755 &&
        find nova -type f |xargs chmod 644 &&
        find novaclient -type d |xargs chmod 755 &&
        find novaclient -type f |xargs chmod 644 &&
        find glance -type d |xargs chmod 755 &&
        find glance -type f |xargs chmod 644 &&
        find glance_store -type d |xargs chmod 755 &&
        find glance_store -type f |xargs chmod 644 &&
        find glanceclient -type d |xargs chmod 755 &&
        find glanceclient -type f |xargs chmod 644 &&
        echo "replace code finish,please modify conf file and restart service." 
    elif [ $2 == "recover" ]; then
        cd /usr/lib/python2.7/site-packages/ &&
        rm -rf nova && rm -rf novaclient &&
        rm -rf glance && rm -rf glanceclient && rm -rf glance_store &&

        mv glance_bak_$dt glance &&
        mv glance_store_bak_$dt glance_store &&
        mv glanceclient_bak_$dt glanceclient &&
        mv nova_bak_$dt nova &&
        mv novaclient_bak_$dt novaclient &&

        rm -f /etc/nova/nova.conf && mv /etc/nova/nova.conf_bak_$dt /etc/nova/nova.conf && 
        rm -f /etc/neutron/neutron.conf && mv /etc/neutron/neutron.conf_bak_$dt /etc/neutron/neutron.conf && 
        rm -f /etc/glance/glance-api.conf && mv /etc/glance/glance-api.conf_bak_$dt /etc/glance/glance-api.conf && 
        rm -f /etc/cinder/cinder.conf && mv /etc/cinder/cinder.conf_bak_$dt /etc/cinder/cinder.conf && 
        echo "recover finish, please restart service." 
    else
        echo "Usage: service control|compute backup|replace|recover"
    fi
elif [ $1 == "compute" ]; then
    echo "starting……" 
    if [ $2 == "backup" ]; then
        mv /usr/lib/python2.7/site-packages/novaclient /usr/lib/python2.7/site-packages/novaclient_bak_$dt &&
        mv /usr/lib/python2.7/site-packages/glanceclient /usr/lib/python2.7/site-packages/glanceclient_bak_$dt &&

        cp -p /etc/nova/nova.conf /etc/nova/nova.conf_bak_$dt && 
        cp -p /etc/neutron/neutron.conf /etc/neutron/neutron.conf_bak_$dt &&         
        echo "backup code and configuration finish" 
    elif [ $2 == "replace" ]; then
        cd /usr/lib/python2.7/site-packages/ &&
        cp -a novaclient /usr/lib/python2.7/site-packages/ &&
        cp -a glanceclient /usr/lib/python2.7/site-packages/ &&
        find novaclient -type d |xargs chmod 755 &&
        find novaclient -type f |xargs chmod 644 &&
        find glanceclient -type d |xargs chmod 755 &&
        find glanceclient -type f |xargs chmod 644 &&
        echo "replace code finish,please modify conf file and restart service." 
    elif [ $2 == "recover" ]; then
        cd /usr/lib/python2.7/site-packages/ &&
        rm -rf novaclient && rm -rf glanceclient &&
        rm -f /etc/nova/nova.conf && mv /etc/nova/nova.conf_bak_$dt /etc/nova/nova.conf && 
        rm -f /etc/neutron/neutron.conf && mv /etc/neutron/neutron.conf_bak_$dt /etc/neutron/neutron.conf && 
        mv glanceclient_bak_$dt glanceclient &&
        mv novaclient_bak_$dt novaclient &&
        echo "recover code and configuration finish" 
    else
        echo "Usage: service control|compute backup|replace|recover"
    fi
else
    echo "Usage: service control|compute backup|replace|recover"
fi
