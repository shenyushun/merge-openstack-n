# -*- coding: utf-8 -*-

'''
Auth:__XsY__
CreateDate: 2019-12-23
Talk Is Cheap,Show Me The Code.
'''

from utils import *

SRC_ENGINE = get_engine('root', 'root123', '100.69.6.88', 'cinder')
DEST_ENGINE = get_engine('root', 'root123', '100.69.6.94', 'cinder')

CINDER_TABLES = [
    {"table": "messages", 'clear_id': False},
    {"table": "driver_initiator_data"},
    # {"table": "quota_classes"},
    {"table": "quotas"},
    {"table": "quota_usages"},
    {"table": "clusters"},
    # 有逻辑关联但是使用cluster_name，所以处理时注意顺序要在clusters完成后写入
    {"table": "services", 'child': [
        {"table": "workers", "s_column": "service_id", "p_column": "id"}
    ]},
    # 有逻辑关联但是使用cluster_name，所以处理时注意顺序要在clusters完成后写入
    {"table": "consistencygroups", 'clear_id': False},
    {"table": "cgsnapshots", 'clear_id': False},
    {"table": "group_types", 'clear_id': False, 'child': [
        {"table": "group_type_specs", "s_column": "group_type_id", "p_column": "id"},
        {"table": "group_type_projects",
            "s_column": "group_type_id", "p_column": "id"},
    ]},
    # 依赖cluster_name和group_type_id
    {"table": "groups", 'clear_id': False},
    # 依赖group_id和group_type_id
    {"table": "group_snapshots", 'clear_id': False},
    {"table": "volume_types", 'clear_id': False, 'child': [
        {"table": "encryption", 'clear_id': False,
            "s_column": "volume_type_id", "p_column": "id"},
        {"table": "volume_type_projects",
            "s_column": "volume_type_id", "p_column": "id"},
        {"table": "volume_type_extra_specs",
            "s_column": "volume_type_id", "p_column": "id"},
    ]},
    {"table": "group_volume_type_mapping"},  # 依赖volume_type_id和group_id
    {"table": "volumes", 'clear_id': False},
    {"table": "transfers", 'clear_id': False},
    {"table": "backups", 'clear_id': False},
    {"table": "volume_attachment", 'clear_id': False},
    {"table": "volume_metadata"},
    {"table": "volume_glance_metadata"},
    {"table": "volume_admin_metadata"},
    {"table": "snapshots", 'clear_id': False},
    {"table": "snapshot_metadata"},
]

def merge_quality_of_service_specs():
    # NOTE 自关联的表先写根数据
    data = pd.read_sql_table("quality_of_service_specs", SRC_ENGINE)
    if data.empty:
        print("quality_of_service_specs is empty...")
        return
    data_root = data[data['specs_id'].isnull()]
    data = data[~data['specs_id'].isnull()]
    tb = [
        {"table": "quality_of_service_specs", 'clear_id': False}
    ]
    write_root_table(tb, SRC_ENGINE, DEST_ENGINE, src_data_handly=data_root)
    write_root_table(tb, SRC_ENGINE, DEST_ENGINE, src_data_handly=data)




def merge_reservations():
    data = pd.read_sql_table("reservations", SRC_ENGINE)
    if data.empty:
        print("reservations is empty...")
        return

    #quotas_old = pd.read_sql_table("quotas", SRC_ENGINE)
    #quotas_new = pd.read_sql_table("quotas", DEST_ENGINE)
    #merged_table = merge_parent_table(quotas_old, quotas_new)
    #data = modify_table_relation_id(
    #    data, 'allocated_id', 'id', merged_table)
    quota_usages_old = pd.read_sql_table("quota_usages", SRC_ENGINE)
    quota_usages_new = pd.read_sql_table("quota_usages", DEST_ENGINE)
    merged_table = merge_parent_table(
        quota_usages_old, quota_usages_new)
    data = modify_table_relation_id(data, 'usage_id', 'id', merged_table)
    time_flag = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    write_data_to_table('reservations',
                        data, time_flag, DEST_ENGINE)


if __name__ == "__main__":
    # check_data_exist(SRC_ENGINE)
    merge_quality_of_service_specs() # volume_type依赖这个表
    write_root_table(CINDER_TABLES, SRC_ENGINE, DEST_ENGINE)
    merge_reservations()
    print("Finish merge!")
