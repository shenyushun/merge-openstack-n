# -*- coding: utf-8 -*-

'''
Auth:__XsY__
CreateDate: 2019-11-28
Talk Is Cheap,Show Me The Code.
'''

# TODO skip and logging duplicated instance uuid.

from datetime import datetime
from utils import *

SRC_ENGINE = get_engine('nova', 'nova123', '100.69.6.88', 'nova_api')
DEST_ENGINE = get_engine('nova', 'nova123', '100.69.6.94', 'nova_api')

NOVA_API_TABLES = [
    {"table": "key_pairs"},
    {"table": "request_specs"},
    {"table": "build_requests"},
    {"table": "instance_groups", 'child': [
        {"table": "instance_group_policy",
            "s_column": "group_id", "p_column": "id"},
        {"table": "instance_group_member",
            "s_column": "group_id", "p_column": "id"},
    ]},
    {"table": "aggregates", 'child': [
        {"table": "aggregate_hosts", "s_column": "aggregate_id", "p_column": "id"},
        {"table": "aggregate_metadata", "s_column": "aggregate_id", "p_column": "id"},
    ]},
    {"table": "resource_providers", 'child': [
        {"table": "inventories", "s_column": "resource_provider_id", "p_column": "id"},
        {"table": "allocations", "s_column": "resource_provider_id", "p_column": "id"}
    ]},
    {"table": "cell_mappings", 'child': [
        {"table": "host_mappings", "s_column": "cell_id", "p_column": "id"},
        {"table": "instance_mappings", "s_column": "cell_id", "p_column": "id"}
    ]},
]


def merge_flavors():
    old_data = pd.read_sql_table("flavors", SRC_ENGINE)
    new_data = pd.read_sql_table("flavors", DEST_ENGINE)
    duplicate_name = check_duplicated(old_data['name'], new_data['name'])
    old_data = old_data[~old_data['name'].isin(duplicate_name)]
    duplicate_flavorid = check_duplicated(old_data['flavorid'], new_data['flavorid'])
    old_data = old_data[~old_data['flavorid'].isin(duplicate_flavorid)]
    tb = [{"table": "flavors", 'child': [
        {"table": "flavor_extra_specs",
            "s_column": "flavor_id", "p_column": "id"},
        {"table": "flavor_projects",
            "s_column": "flavor_id", "p_column": "id"},
    ]}]
    write_root_table(tb, SRC_ENGINE, DEST_ENGINE, src_data_handly=old_data)


def merge_resource_provider_aggregates():
    data = pd.read_sql_table("resource_provider_aggregates", SRC_ENGINE)
    if data.empty:
        print("resource_provider_aggregates is empty...")
        return

    aggregates_old = pd.read_sql_table("aggregates", SRC_ENGINE)
    aggregates_new = pd.read_sql_table("aggregates", DEST_ENGINE)
    merged_table = merge_parent_table(
        aggregates_old, aggregates_new)
    data = modify_table_relation_id(
        data, 'aggregates_id', 'id', merged_table)
    resource_provider_old = pd.read_sql_table("resource_provider", SRC_ENGINE)
    resource_provider_new = pd.read_sql_table("resource_provider", DEST_ENGINE)
    merged_table = merge_parent_table(
        resource_provider_old, resource_provider_new)
    data = modify_table_relation_id(data, 'network_id', 'id', merged_table)
    time_flag = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    write_data_to_table('resource_provider_aggregates',
                        data, time_flag, DEST_ENGINE)


if __name__ == "__main__":
    # check_data_exist(SRC_ENGINE)
    write_root_table(NOVA_API_TABLES, SRC_ENGINE, DEST_ENGINE)
    merge_flavors()
    merge_resource_provider_aggregates()
    print("Finish merge!")
