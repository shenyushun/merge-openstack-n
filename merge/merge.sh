#!/bin/bash

# 執行合併腳本，請先修改各個文件中數據庫連接部分
databases=(glance cinder neutron nova nova_api)
for i in ${databases[*]}; do
    python merge_"$i".py
done
