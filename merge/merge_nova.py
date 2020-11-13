# -*- coding: utf-8 -*-

'''
Auth:__XsY__
CreateDate: 2019-11-25
Talk Is Cheap,Show Me The Code.
'''

# TODO skip and logging duplicated instance uuid.

from utils import *

SRC_ENGINE = get_engine('nova', 'nova123', '100.69.6.88', 'nova')
DEST_ENGINE = get_engine('nova', 'nova123', '100.69.6.94', 'nova')

#! NOTE below table just run once for one nova database otherwise will raise data duplicated error.
NOVA_TABLES = [
    {"table": "instances"},
    {"table": "instance_id_mappings"},
    {"table": "tags"},
    {"table": "instance_info_caches"},
    {"table": "instance_extra"},
    {"table": "instance_faults"},
    {"table": "instance_metadata"},
    {"table": "instance_system_metadata"},
    {"table": "migrations"},
    # NOTE don't clear ID of snapshots table
    {"table": "snapshots", 'clear_id': False},
    {"table": "snapshot_id_mappings"},
    {"table": "block_device_mapping"},
    {"table": "volume_usage_cache"},
    {"table": "volume_id_mappings"},
    {"table": "console_auth_tokens"},
    {"table": "instance_actions", 'child': [
        {"table": "instance_actions_events", "s_column": "action_id", "p_column": "id"}]},
    {"table": "instance_types", 'child': [
        {"table": "instance_type_extra_specs",
            "s_column": "instance_type_id", "p_column": "id"},
        {"table": "instance_type_projects",
            "s_column": "instance_type_id", "p_column": "id"},
    ]},
    {"table": "instance_groups", 'child': [
        {"table": "instance_group_policy",
            "s_column": "group_id", "p_column": "id"},
        {"table": "instance_group_member",
            "s_column": "group_id", "p_column": "id"},
    ]},
    {"table": "quota_usages", 'child': [
        {"table": "reservations", "s_column": "usage_id", "p_column": "id"}]},
    {"table": "console_pools", 'child': [
        {"table": "consoles", "s_column": "pool_id", "p_column": "id"}]},
    {"table": "certificates"},
    {"table": "key_pairs"},
    {"table": "dns_domains"},
    {"table": "cells"},
    {"table": "task_log"},
    {"table": "quotas"},
    {"table": "quota_classes"},
    {"table": "project_user_quotas"},
    {"table": "bw_usage_cache"},
    {"table": "s3_images"},
    {"table": "agent_builds"},
    {"table": "provider_fw_rules"},
    {"table": "security_group_default_rules"},
    {"table": "compute_nodes", 'child': [
        {"table": "pci_devices", "s_column": "compute_node_id", "p_column": "id"}]},
    {"table": "aggregates", 'child': [
        {"table": "aggregate_hosts", "s_column": "aggregate_id", "p_column": "id"},
        {"table": "aggregate_metadata", "s_column": "aggregate_id", "p_column": "id"},
    ]},
    {"table": "networks", 'child': [
        {"table": "virtual_interfaces", "s_column": "network_id", "p_column": "id"}]},
    {"table": "resource_providers", 'child': [
        {"table": "inventories", "s_column": "resource_provider_id", "p_column": "id"},
        {"table": "allocations", "s_column": "resource_provider_id", "p_column": "id"}
    ]},
]


def merge_services():
    table = [{"table": "services"},]
    data = pd.read_sql("select * from services where `binary` = 'nova-compute'", SRC_ENGINE)
    write_root_table(table, SRC_ENGINE, DEST_ENGINE, src_data_handly=data)


def merge_security_groups():
    table = {"table": "security_groups", 'child': [
        {"table": "security_group_instance_association",
            "s_column": "security_group_id", "p_column": "id"}
    ]}
    merge_data_not_duplicates(table, 'project_id', SRC_ENGINE, DEST_ENGINE)


def merge_security_group_rules():
    data = pd.read_sql_table("security_group_rules", SRC_ENGINE)
    if data.empty:
        print("security_group_rules is empty...")
        return
    security_groups_old = pd.read_sql_table("security_groups", SRC_ENGINE)
    security_groups_new = pd.read_sql_table("security_groups", DEST_ENGINE)
    merged_table = merge_parent_table(security_groups_old, security_groups_new)
    data = modify_table_relation_id(
        data, 'parent_group_id', 'id', merged_table)
    data = modify_table_relation_id(data, 'group_id', 'id', merged_table)
    time_flag = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    write_data_to_table('security_group_rules', data, time_flag, DEST_ENGINE)


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


def merge_fixed_ips():
    data = pd.read_sql_table("fixed_ips", SRC_ENGINE)
    if data.empty:
        print("fixed_ips is empty...")
        return

    virtual_interfaces_old = pd.read_sql_table(
        "virtual_interfaces", SRC_ENGINE)
    virtual_interfaces_new = pd.read_sql_table(
        "virtual_interfaces", DEST_ENGINE)
    merged_table = merge_parent_table(
        virtual_interfaces_old, virtual_interfaces_new)
    data = modify_table_relation_id(
        data, 'virtual_interface_id', 'id', merged_table)

    networks_old = pd.read_sql_table("networks", SRC_ENGINE)
    networks_new = pd.read_sql_table("networks", DEST_ENGINE)
    merged_table = merge_parent_table(networks_old, networks_new)
    data = modify_table_relation_id(data, 'network_id', 'id', merged_table)

    backup_table = data.copy()
    time_flag = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    write_data_to_table('fixed_ips', data, time_flag, DEST_ENGINE)

    new_data = pd.read_sql(
        "select * from fixed_ips where updated_at = '%s'" % time_flag, DEST_ENGINE)
    condition_str = create_in_condition_str(backup_table['id'])
    query_sql = create_in_query_sql(
        'floating_ips', 'fixed_ip_id', condition_str)
    child_data = pd.read_sql(query_sql, SRC_ENGINE)
    if child_data.empty:
        print("floating_ips is empty...")
        return
    merge_table = merge_parent_table(backup_table, new_data)
    child_data = modify_table_relation_id(
        child_data, 'fixed_ip_id', 'id', merge_table)
    write_data_to_table('floating_ips', child_data, time_flag, DEST_ENGINE)


if __name__ == "__main__":
    # check_data_exist(SRC_ENGINE)

    # NOTE run this func first
    write_root_table(NOVA_TABLES, SRC_ENGINE, DEST_ENGINE)
    merge_services()
    merge_security_groups()
    merge_security_group_rules()
    merge_fixed_ips()
    merge_resource_provider_aggregates()
    print("Finish merge!")
