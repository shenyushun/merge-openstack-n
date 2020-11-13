#!/bin/bash

# openstack-service start|stop  停止所有服务 谨慎执行

control_service=(openstack-cinder-api.service\ 
    openstack-cinder-scheduler.service\ 
    openstack-cinder-volume.service\ 
    openstack-cinder-backup.service\ 
    openstack-glance-api.service\ 
    openstack-glance-registry.service\ 
    openstack-nova-api.service\ 
    openstack-nova-conductor.service\ 
    openstack-nova-consoleauth.service\ 
    openstack-nova-novncproxy.service\ 
    openstack-nova-scheduler.service\ 
    openstack-nova-compute.service\ 
    neutron-dhcp-agent.service\ 
    neutron-metadata-agent.service\ 
    neutron-openvswitch-agent.service\ 
    neutron-server.service)

compute_service=(openstack-nova-compute.service neutron-openvswitch-agent.service)

if [ $1 == "control" ]; then
    if [ $2 == "start" ]; then
        for i in ${control_service[*]}; do
            echo "start:" $i
            systemctl start $i
        done
    elif [ $2 == "stop" ]; then
        for i in ${control_service[*]}; do
            echo "stop:" $i
            systemctl stop $i
        done
    else
        echo "Usage: service control|compute start|stop"
    fi
elif [ $1 == "compute" ]; then
    if [ $2 == "start" ]; then
        for i in ${compute_service[*]}; do
            echo "start:" $i
            systemctl start $i
        done
    elif [ $2 == "stop" ]; then
        for i in ${compute_service[*]}; do
            echo "stop:" $i
            systemctl stop $i
        done
    else
        echo "Usage: service control|compute start|stop"
    fi
else
    echo "Usage: service control|compute start|stop"
fi
