# -*- coding: utf-8 -*-

'''
Auth:__XsY__
CreateDate: 2019-11-28
Talk Is Cheap,Show Me The Code.
'''

from utils import *

SRC_ENGINE = get_engine('glance', 'glance123', '100.69.6.88', 'glance')
DEST_ENGINE = get_engine('glance', 'glance123', '100.69.6.94', 'glance')

GLANCE_TABLES = [
    {"table": "tasks", 'clear_id': False},
    # 有逻辑关联但是使用UUID，所以处理时注意顺序要在tasks完成后写入
    {"table": "task_info", 'clear_id': False},
    {"table": "artifacts", 'clear_id': False},
    # 有逻辑关联但是使用UUID，所以处理时注意顺序要在artifacts完成后写入
    {"table": "artifact_dependencies", 'clear_id': False},
    {"table": "artifact_tags", 'clear_id': False},
    {"table": "artifact_properties", 'clear_id': False},
    {"table": "artifact_blobs", 'clear_id': False},
    # 有逻辑关联但是使用UUID，所以处理时注意顺序要在artifact_blobs完成后写入
    {"table": "artifact_blob_locations", 'clear_id': False},

    # {"table": "metadef_resource_types"},
    {"table": "metadef_namespaces", 'child': [
        {"table": "metadef_tags", "s_column": "namespace_id", "p_column": "id"},
        {"table": "metadef_objects", "s_column": "namespace_id", "p_column": "id"},
        {"table": "metadef_properties", "s_column": "namespace_id", "p_column": "id"},
    ]},
]


def merge_images():
    table = {"table": "images", 'clear_id': False, 'child': [
            {"table": "image_members", "s_column": "image_id",
             "p_column": "id", "condition_type": "str"},
            {"table": "image_properties", "s_column": "image_id",
             "p_column": "id", "condition_type": "str"},
            {"table": "image_tags", "s_column": "image_id",
             "p_column": "id", "condition_type": "str"},
            {"table": "image_locations", "s_column": "image_id",
             "p_column": "id", "condition_type": "str"},
    ]}
    merge_data_not_duplicates(table, 'id', SRC_ENGINE, DEST_ENGINE)


def merge_metadef_namespace_resource_types():
    data = pd.read_sql_table("metadef_namespace_resource_types", SRC_ENGINE)
    if data.empty:
        print("metadef_namespace_resource_types is empty...")
        return

    old1 = pd.read_sql_table("metadef_namespaces", SRC_ENGINE)
    new1 = pd.read_sql_table("metadef_namespaces", DEST_ENGINE)
    merged_table = merge_parent_table(old1, new1)
    data = modify_table_relation_id(
        data, 'namespace_id', 'id', merged_table)
    old2 = pd.read_sql_table("metadef_resource_types", SRC_ENGINE)
    new2 = pd.read_sql_table("metadef_resource_types", DEST_ENGINE)
    merged_table = merge_parent_table(old2, new2)
    data = modify_table_relation_id(
        data, 'resource_type_id', 'id', merged_table)
    time_flag = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    write_data_to_table('metadef_namespace_resource_types',
                        data, time_flag, DEST_ENGINE)


if __name__ == "__main__":
    # check_data_exist(SRC_ENGINE)
    merge_images()
    write_root_table(GLANCE_TABLES, SRC_ENGINE, DEST_ENGINE)
    merge_metadef_namespace_resource_types()
    print("Finish merge!")
